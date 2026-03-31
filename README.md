
# Serverless URL Monitoring System

A production-ready, serverless synthetic monitoring tool designed to check website availability. It is built with Python, packaged into a Docker container, hosted on AWS Lambda, and deployed automatically via GitHub Actions (CI/CD).

---

## How It Works
1. Probe: A Python script uses the `requests` library to ping a specified URL and verify its status.
2. Container: The app is packaged using the official AWS Lambda Python 3.11 base image.
3. Trigger: Amazon EventBridge (CloudWatch Events) wakes up the Lambda function every 5 minutes to run the check.
4. CI/CD Pipeline: Any `git push` to the `main` branch triggers a GitHub Action that builds the Docker image, pushes it to Amazon ECR, and updates the Lambda function.

---

## Tech Stack
* Language: Python 3.11
* Containerization: Docker
* Cloud Provider: AWS (Lambda, ECR, EventBridge, IAM)
* CI/CD: GitHub Actions

---

## 📁 Project Structure
```text
├── .github/workflows/
│   └── deploy.yml          # GitHub Actions CI/CD workflow
├── url-monitoring.py       # Main Python script (Lambda Handler)
├── Dockerfile              # Docker configuration for AWS Lambda
├── requirements.txt        # Python dependencies
└── README.md               

