# github-gcp-repo-sync

To deploy this:

1. **Create a terraform.tfvars file:**
````terraform
project_id        = "your-gcp-project-id"
region            = "us-central1"
github_repo_owner = "your-github-username"
github_repo_name  = "your-repo-name"
bucket_name       = "your-unique-bucket-name"
````

2. **Deploy with Terraform:**
```bash
terraform init
terraform plan
terraform apply
```

3. **Connect GitHub:**
After applying, you'll need to connect your GitHub repository to Cloud Build:
- Go to Cloud Build > Triggers in the GCP Console
- Click "Connect Repository"
- Follow the OAuth flow to connect your GitHub account

4. **Add the cloudbuild.yaml to your repository:**
Commit the `cloudbuild.yaml` file to your repository's root.

This setup will:
- ✅ Archive your main branch on every push
- ✅ Store archives in both GCS and Artifact Registry
- ✅ Include metadata with timestamps and commit info
- ✅ Use a dedicated service account with minimal permissions
- ✅ Exclude common unnecessary files from archives

The archives will be stored with timestamps and commit SHAs for easy identification.