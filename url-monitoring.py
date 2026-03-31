import requests
import json
import os
import boto3


def lambda_handler(event, context):
    # URL to monitor
    url = os.environ.get('TARGET_URL', 'https://www.google.com')
    sns_topic_arn = os.environ.get('SNS_TOPIC_ARN')

    sns_client = boto3.client('sns')
    

    try:
        # 1. Send request
        response = requests.get(url, timeout=5)
        status = response.status_code
        
        # 2. Prepare message
        if status == 200:
            message = f"Website {url} is UP (Status: 200)"
        else:
            message = f"Website {url} has ISSUES (Status: {status})"
            
    except Exception as e:
        message = f"ERROR: Could not connect to {url}. Details: {e}"

    # 3. Result (see AWS CloudWatch logs)
    print(message)
    
    if sns_topic_arn:
        try:
            sns_client.publish(
                TopicArn=sns_topic_arn,
                Message=message,
                Subject=f"URL Monitoring Alert: {url} is DOWN!"
            )
            print(f"Alert sent to SNS topic: {sns_topic_arn}")
        except Exception as e:
            print(f"Failed to send SNS alert: {e}")
        
    # 4. Return the response to AWS Lambda
    return {
        'statusCode': 200,
        'body': json.dumps({
            'success': success,
            'message': message
        })
    }
#if __name__ == "__main__":
    print("Running local test...")
    lambda_handler({}, {})