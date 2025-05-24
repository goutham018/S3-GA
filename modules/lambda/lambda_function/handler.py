import json
import boto3
import urllib.parse
import requests

def main(event, context):
    s3 = boto3.client('s3')
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(record['s3']['object']['key'])
        response = s3.get_object(Bucket=bucket, Key=key)
        logs = response['Body'].read().decode('utf-8')
        requests.post("https://your-api-endpoint.com/ci-logs", json={"key": key, "logs": logs})
