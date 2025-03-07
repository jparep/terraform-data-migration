import json

def lambda_handler(event, context):
    # TODO: Implement Lambda function logic
    print("Lambda function triggered with event:", json.dumps(event))
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }