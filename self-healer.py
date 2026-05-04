import os
import boto3

client = boto3.client("lambda")
def lambda_handler(event, context):
    function_name = os.environ.get('LAMBDA_FUNCTION_NAME', 'url-monitoring')
    alias_name =  'live'

    try:
        response = client.get_alias(
            FunctionName=function_name,
            Name=alias_name
        )
        current_version = response['FunctionVersion']
        print(f"Current version of alias '{alias_name}': {current_version}")    

        if current_version == "$LATEST" or not current_version.isdigit():
            print(f"Current version '{current_version}' is not a valid number or is $LATEST.")
            return {"status": "skipped", "message": "Already on $LATEST or non-numeric version"}
        if int(current_version) <= 1:
            print(f"Cannot rollback. Current version '{current_version}' is the earliest version.")
            return {"status": "skipped", "message": "Already at the earliest version, cannot rollback."}
        target_version = str(int(current_version) - 1)
        print(f"Rolling back alias '{alias_name}' to version {target_version}...")

        client.update_alias(
            FunctionName=function_name, 
            Name=alias_name,
            FunctionVersion=target_version,
        )
        print(f"Rolled back alias '{alias_name}' to version {target_version}")
        return {"status": "success", "message": f"Rolled back to version {target_version}"}
    except Exception as e:
        raise e
    