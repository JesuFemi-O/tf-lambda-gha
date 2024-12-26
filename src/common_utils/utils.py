from faker import Faker

def generate_payload():
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
    return payload