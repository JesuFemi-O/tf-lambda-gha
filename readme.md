# AWS Lambda Deployment with Terraform and GitHub Actions

This project demonstrates deploying an AWS Lambda function, layers, and associated infrastructure using **Terraform** and **GitHub Actions**. It includes dynamic layer building, S3 bucket management, and Function URL configuration.

---

## **Project Structure**

```plaintext
.
├── layers
│   ├── requirements.txt        # Dependencies for Lambda layers
│   ├── custom_layer            # Directory for building Lambda layers
│   │   └── python              # Python dependencies installed here
├── src
│   ├── lambda_function.py      # Main Lambda function code
│   └── lambda_function.zip     # (Generated) Zipped Lambda function
├── terraform
│   ├── iam.tf                  # IAM roles and permissions
│   ├── lambda.tf               # Lambda function configuration
│   ├── layer.tf                # Lambda layer configuration
│   └── main.tf                 # Terraform backend and provider setup
├── makefile                    # Build and deployment commands
└── .github
    └── workflows
        └── deploy.yml          # GitHub Actions workflow for CI/CD
```

---

## **Features**

1. **AWS Lambda Deployment**:
   - Deploys Lambda functions and layers dynamically using Terraform.

2. **Dynamic Layer Building**:
   - Builds Lambda layers from `requirements.txt` at runtime.

3. **Terraform Backend**:
   - Uses an S3 bucket with versioning enabled for state management.

4. **GitHub Actions CI/CD**:
   - Automates deployment triggered by changes in `layers/`, `terraform/`, `src/`, or the `makefile`.

5. **Function URL**:
   - Configures a Function URL for the Lambda function.

6. **Filtering for S3 Triggers**:
   - Example provided for attaching an S3 bucket trigger with filters for specific prefixes and suffixes.

---

## **Pre-requisites**

1. **AWS Account**:
   - Ensure you have an AWS account and credentials with sufficient permissions.

2. **Terraform**:
   - Install Terraform (≥1.5.0).

3. **GitHub Secrets**:
   - Add the following secrets to your repository:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`

4. **Dependencies**:
   - Install required Python dependencies:
     ```bash
     pip install -r layers/requirements.txt
     ```

---

## **Setup Instructions**

### **1. Clone the Repository**
```bash
git clone <repository-url>
cd <repository-directory>
```

### **2. Configure Terraform Backend**
Edit `terraform/main.tf` to specify your S3 bucket:
```hcl
backend "s3" {
  bucket = "your-bucket-name"
  key    = "state/terraform.tfstate"
  region = "us-east-2"
}
```

### **3. Build Lambda Layers**
Use the `make` command to build layers:
```bash
make build-layer
```

### **4. Initialize Terraform**
Ensure the S3 backend is created and Terraform is initialized:
```bash
make terraform-init
```

### **5. Deploy Infrastructure**
Run Terraform commands to validate and deploy:
```bash
cd terraform
terraform validate
terraform apply -auto-approve
```

---

## **GitHub Actions Workflow**

The CI/CD pipeline is configured to:
- Trigger on changes in `layers/`, `terraform/`, `src/`, or `makefile`.
- Dynamically build Lambda layers and deploy changes using Terraform.

**Manual Trigger**:
You can manually trigger the workflow via the GitHub Actions interface.

---

#### **Using the Makefile**
The `Makefile` includes commands to simplify common tasks. It supports both environments with and without a specified AWS CLI profile.

#### **Variables**
- **`AWS_REGION`**: AWS region for all operations (default: `us-east-2`).
- **`BUCKET_NAME`**: Name of the S3 bucket used for Terraform backend.
- **`PROFILE`**: (Optional) AWS CLI profile name. If omitted, commands will run without a profile.

#### **Examples**

1. **Without a Profile**:
   By default, no profile is used:
   ```bash
   make create-bucket
   ```

2. **With a Profile**:
   Set the `PROFILE` variable before running commands:
   ```bash
   make PROFILE=my-aws-profile create-bucket
   ```

---

## **Makefile Commands**

| Command             | Description                                  |
|---------------------|----------------------------------------------|
| `make create-bucket` | Creates an S3 bucket for Terraform backend. |
| `make build-layer`   | Builds the Lambda layer from `requirements.txt`. |
| `make terraform-init`| Initializes Terraform with the S3 backend.  |
| `make clean`         | Cleans up generated artifacts.              |

---

## **Function URL**

A Function URL is configured for direct invocation of the Lambda function. After deployment, you can test it using:
```bash
curl -X POST <function-url>
```

---

## **Testing**

1. **Lambda Function**:
   - Test via the AWS Console or invoke the Function URL.
2. **S3 Trigger**:
   - Upload a file to the bucket and observe Lambda logs in CloudWatch.

---

## **Future Enhancements**

- Add monitoring with Amazon CloudWatch Alarms.
- Extend support for additional triggers (e.g., DynamoDB, SQS).
- Configure custom domains for the Function URL.


