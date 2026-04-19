output "vm_public_ip" {
  description = "The public IP address of the newly created VM."
  value       = google_compute_instance.react_vm.network_interface.0.access_config.0.nat_ip
}

output "website_url" {
  description = "The URL to access your deployed React application."
  value       = "http://${google_compute_instance.react_vm.network_interface.0.access_config.0.nat_ip}"
}
