import json
from faker import Faker



def lambda_handler(event, context):
    # Generate a fake payload
    fake = Faker()
    
    payload = {
        "name": fake.name(),
        "email": fake.email(),
        "address": fake.address(),
        "company": fake.company(),
        "phone_number": fake.phone_number(),
        "date_of_birth": fake.date_of_birth().isoformat()
    }
    
    # Return the payload as a JSON response
    return {
        "statusCode": 200,
        "body": json.dumps(payload)
    }
