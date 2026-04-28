import requests
import json
import os
import boto3


def lambda_handler(event, context):
    # URL to monitor
    url = os.environ.get("TARGET_URL", "https://www.google.com")
    sns_topic_arn = os.environ.get("SNS_TOPIC_ARN")

    success = False
    sns_client = boto3.client("sns")

    try:
        response = requests.get(url, timeout=5)
        status = response.status_code

        if status == 200:
            message = f"Website {url} is UP (Status: 200)"
            success = True
        else:
            message = f"Website {url} has ISSUES (Status: {status})"

    except Exception as e:
        message = f"ERROR: Could not connect to {url}. Details: {e}"
        success = False

    print(message)

    if sns_topic_arn and not success:
        try:
            sns_client.publish(
                TopicArn=sns_topic_arn,
                Message=message,
                Subject=f"URL Monitoring Alert: {url} is DOWN!",
            )
            print(f"Alert sent to SNS topic: {sns_topic_arn}")
        except Exception as e:
            print(f"Failed to send SNS alert: {e}")

    return {
        "statusCode": 200,
        "body": json.dumps({"success": success, "message": message}),
    }
    # if __name__ == "__main__":
    # print("Running local test...")
    lambda_handler({}, {})
