import json
from common_utils.utils import generate_payload



def lambda_handler(event, context):
    
    payload = generate_payload()
    
    # Return the payload as a JSON response
    return {
        "statusCode": 200,
        "body": json.dumps(payload)
    }
