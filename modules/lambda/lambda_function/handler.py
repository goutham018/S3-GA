import boto3
import json
import os
import urllib.parse
import requests

s3 = boto3.client('s3')
FASTAPI_URL = os.environ.get("http://13.203.102.146:8000/ci-logs")

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(record['s3']['object']['key'])

        try:
            response = s3.get_object(Bucket=bucket, Key=key)
            logs = response['Body'].read().decode('utf-8')

            print(f"Log file content from S3 ({key}):")
            print(logs)

            # Send to FastAPI endpoint
            if FASTAPI_URL:
                api_response = requests.post(
                    FASTAPI_URL,
                    headers={"Content-Type": "application/json"},
                    data=json.dumps({"key": key, "logs": logs})
                )
                print("API response:", api_response.text)
            else:
                print("FASTAPI_URL is not set")

        except Exception as e:
            print(f"Error processing file {key} from bucket {bucket}. Error: {e}")
            raise e
