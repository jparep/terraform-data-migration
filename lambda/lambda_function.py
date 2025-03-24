import json

def lambda_handler(event, context):
    """Implement Lambda function to convert CSV to Parquet."""
    print("Lambda function triggered with event:", json.dumps(event))
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }