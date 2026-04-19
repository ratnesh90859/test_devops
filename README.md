# Modern React ToDo App - Terraform & Jenkins GCP Deployment

This project contains a modern React frontend along with Infrastructure as Code (Terraform) and CI/CD (Jenkins) pipelines to deploy it onto Google Cloud Platform. 

This repository was designed specifically to help you learn Terraform and Jenkins! Here are the steps to deploy and make your website public.

## Prerequisites
1. **Google Cloud Account**: You need a GCP account and a created Project. Make note of your `Project ID`.
2. **Terraform CLI**: Installed on your local machine.
3. **Jenkins**: Running locally or on a VM.
4. **gcloud CLI**: Installed on your Jenkins agent machine.
5. **Node.js & npm**: Installed on your Jenkins agent.

---

## Step 1: Set Up Infrastructure with Terraform

Terraform will create a Google Cloud Storage bucket, configure it to host a static website, and make the files publicly accessible over the internet.

1. Open your terminal and navigate to the `terraform` directory:
   ```bash
   cd terraform
   ```

2. Authenticate locally with GCP so Terraform can provision resources on your behalf:
   ```bash
   gcloud auth application-default login
   ```

3. Initialize Terraform (this downloads the required GCP plugins):
   ```bash
   terraform init
   ```

4. Run a Terraform plan to see what will be created. You will be prompted for your `project_id`:
   ```bash
   terraform plan
   ```

5. Apply the Terraform configuration to create the bucket:
   ```bash
   terraform apply
   ```
   *(Type `yes` when prompted)*

6. **IMPORTANT**: After apply finishes, it will print some outputs. Note the `bucket_name`! You will need this for the Jenkins pipeline.

---

## Step 2: Set up Jenkins Credentials

Before Jenkins can push the React app to GCP, it needs permission.

1. Go to your Google Cloud Console.
2. Navigate to **IAM & Admin -> Service Accounts**.
3. Create a new Service Account (e.g., `jenkins-deployer`).
4. Give it the role: **Storage Object Admin** so it can write files to your GCS buckets.
5. Click on the new service account -> **Keys** -> **Add Key** -> **Create New Key** -> Choose **JSON**. 
   *(This will download a JSON file to your computer).*
6. Go to your Jenkins Dashboard.
7. Navigate to **Manage Jenkins -> Credentials -> System -> Global credentials -> Add Credentials**.
8. Select **Kind**: `Secret file`.
9. Upload the JSON file you downloaded from GCP.
10. Set **ID** to exactly `gcp-credentials` (this matches the Jenkinsfile).
11. Click **Create**.

---

## Step 3: Run the Jenkins Pipeline

1. In Jenkins, create a new **Pipeline** job.
2. Point it to this Git repository. Note: if this is just a folder on your Mac, you must `git init` and push it to GitHub, or use a local git repository path, or set up a Freestyle project if you don't use Git. (Assuming you have this in a Git Repo).
3. If using this exact `Jenkinsfile`, under **This project is parameterized**, enable it and add a String Parameter named `BUCKET_NAME`.
4. Run the pipeline. When prompted, enter the `bucket_name` output you got from step 1 (e.g., `todo-react-app-1a2b3c4d`).

The pipeline will:
1. Check out your code.
2. Build the beautiful React ToDo App inside the `frontend/` directory.
3. Authenticate with GCP using `gcloud`.
4. Sync the built `frontend/dist/` directory into your Cloud Storage bucket.

---

## Step 4: View the Website!

After the Jenkins deploy is successful, navigate to the `website_url` that Terraform outputted. It will look like: 
`http://storage.googleapis.com/YOUR_BUCKET_NAME/index.html`

Congratulations! You have automated infrastructure provisioning and CI/CD for a modern application.
