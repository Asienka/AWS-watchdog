
# Serverless URL Monitoring System

A production-ready, serverless synthetic monitoring tool designed to check website availability. It is built with Python, packaged into a Docker container, hosted on AWS Lambda, and managed entirely via Terraform.

---
## Architecture
The system follows a modern DevOps approach:

1. Infrastructure as Code: Managed by Terraform, ensuring environment consistency.
2. Compute: AWS Lambda running a Dockerized Python 3.11 environment.
3. Storage: Amazon ECR (Elastic Container Registry) stores the application images.
4. Alerting: Amazon SNS sends instant email notifications if a website returns a non-200 status code.
5. Automation: Amazon EventBridge triggers the check every 5 minutes (disabl


## How It Works
1. Probe: A Python script uses the `requests` library to ping a specified URL and verify its status.
2. Container: The app is packaged using the official AWS Lambda Python 3.11 base image.
3. Trigger: Amazon EventBridge (CloudWatch Events) wakes up the Lambda function every 5 minutes to run the check.
4. CI/CD Pipeline: Any `git push` to the `main` branch triggers a GitHub Action that builds the Docker image, pushes it to Amazon ECR, and updates the Lambda function.

---

## Tech Stack
* Language: Python 3.11 (requests library)
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
│   ├── main.tf             # Core resources (to be refactored)
├── app/
│   ├── url-monitoring.py   # Main Python script (Lambda Handler)
│   ├── Dockerfile          # Docker configuration for AWS Lambda
│   └── requirements.txt    # Python dependencies
└── README.md            

