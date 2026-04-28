
# Serverless URL Monitoring System

A production-ready, serverless synthetic monitoring tool designed to check website availability. It is built with Python, packaged into a Docker container, hosted on AWS Lambda, and managed entirely via Terraform with automated versioning and rollback capabilities.

---
## Architecture
The system follows a modern DevOps approach:

1. Infrastructure as Code: Managed by Terraform, ensuring environment consistency.
2. Containerization: AWS Lambda runs a Dockerized Python 3.11 environment for consistent local-to-cloud behavior.
3. Immutable Deploys: Every deployment is tagged with a unique Git SHA, ensuring we know exactly which code is running in production
4. Zero-Downtime Rollbacks: Uses AWS Lambda Aliases (live alias) to point to specific immutable versions, allowing near-instant recovery if a new version fails.
5. Alerting and Observability: Amazon SNS provides instant notifications, while CloudWatch Dashboards monitor latency and error rates.
6. Automation: Amazon EventBridge triggers the check every 5 minutes 

## How It Works
1. Probe: A Python script uses the `requests` library to ping a specified URL and verify its status.
2. Container: The app is packaged using the official AWS Lambda Python 3.11 base image.
3. Trigger: Amazon EventBridge (CloudWatch Events) wakes up the Lambda function every 5 minutes to run the check.
4. CI/CD Pipeline: Any `git push` or `pull request` to the `main` branch triggers GitHub Actions:
 - Linting: GitHub Actions runs Ruff and terraform fmt to ensure code quality.
 - Build: A new Docker image is built and pushed to Amazon ECR with a unique SHA tag.
 - Deploy: Terraform updates the Lambda function, publishes a new version, and shifts the live alias.

---

## Tech Stack
* Language: Python 3.11 
* Infrastructure: Terraform (IaC)
* Containerization: Docker (Multi-platform builds for `linux/amd64`)
* Cloud Provider: AWS (Lambda, ECR, SNS, EventBridge, IAM, CloudWatch)
* CI/CD: GitHub Actions

---

## 📁 Project Structure
```text
├── .github/workflows/
│   └── deploy.yml          # GitHub Actions CI/CD workflow
├── terraform/              # Infrastructure as Code (IaC)
│   ├── cloudwatch.tf       # Monitoring & Observability: Dashboards and Alarms
│   ├── ecr.tf              # Container Registry
│   ├── iam.tf              # Security: Least-privilege roles and policies
│   ├── lambda.tf           # Lambda function, Aliases (live), and Versioning logic
│   ├── output.tf           # URLs, ARNs, and resource IDs for easy reference
│   ├── providers.tf        # AWS provider settings and S3 Remote State
│   ├── variables.tf        #Input variables
├── url-monitoring.py   # Main Python script (Lambda Handler and URL monitoring)
├── Dockerfile          # Docker configuration for AWS Lambda
|── requirements.txt    # Python dependencies
└── README.md            

