import requests
import json

def lambda_handler(event, context):
    # URL to monitor
    url = "https://www.google.com"
    
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
    
    # 4. Return the response to AWS Lambda
    return {
        'statusCode': 200,
        'body': json.dumps(message)
    }
#if __name__ == "__main__":
    print("Running local test...")
    lambda_handler({}, {})