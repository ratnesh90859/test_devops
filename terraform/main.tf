# We use the default network instead of creating a complex VPC for simplicity
data "google_compute_network" "default" {
  name = "default"
}

# Firewall rule to allow HTTP (port 80) and SSH (port 22)
resource "google_compute_firewall" "web_firewall" {
  name    = "allow-http-ssh"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from anywhere
}

# The Virtual Machine Instance
resource "google_compute_instance" "react_vm" {
  name         = "react-todo-vm"
  machine_type = "e2-micro" # Free tier eligible
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10 # 10GB disk
    }
  }

  network_interface {
    network = data.google_compute_network.default.name
    # Assigns a public External IP
    access_config {}
  }

  # Add SSH key explicitly so Jenkins can securely access the VM
  metadata = {
    ssh-keys = "${var.ssh_user}:${file("~/.ssh/gcp_jenkins_rsa.pub")}"
  }

  # Startup script runs once when VM boots up for the first time.
  # We install Nginx and prepare the folder for Jenkins to write to.
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx

    # Create the folder and make our Jenkins user the owner so it can write files
    mkdir -p /var/www/html
    chown -R jenkins:jenkins /var/www/html
    chmod -R 755 /var/www/html
    
    systemctl enable nginx
    systemctl start nginx
  EOT
}
