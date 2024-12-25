

# Variables
AWS_REGION=us-east-2
BUCKET_NAME=terraform-state-ruffnotes
PROFILE=vscode
LAYER_ZIP=layers/lambda_layer.zip
REQUIREMENTS_FILE=layers/requirements.txt

.PHONY: create-bucket terraform-init build-layer clean

# Create the S3 bucket for Terraform backend
# Create the S3 bucket for Terraform backend
create-bucket:
	@echo "Checking if bucket $(BUCKET_NAME) exists..."
	@aws s3api head-bucket --bucket $(BUCKET_NAME) --region $(AWS_REGION) --profile $(PROFILE) >/dev/null 2>&1 || \
	( echo "Bucket does not exist. Creating bucket $(BUCKET_NAME) in region $(AWS_REGION)..."; \
	aws s3api create-bucket \
		--bucket $(BUCKET_NAME) \
		--region $(AWS_REGION) \
		--create-bucket-configuration LocationConstraint=$(AWS_REGION) \
		--profile $(PROFILE) >/dev/null )
	@echo "Bucket $(BUCKET_NAME) exists."
	@echo "Checking if versioning is already enabled on bucket $(BUCKET_NAME)..."
	@aws s3api get-bucket-versioning --bucket $(BUCKET_NAME) --profile $(PROFILE) | grep '"Status": "Enabled"' >/dev/null 2>&1 || \
	( echo "Versioning is not enabled. Enabling versioning on bucket $(BUCKET_NAME)..."; \
	aws s3api put-bucket-versioning \
		--bucket $(BUCKET_NAME) \
		--versioning-configuration Status=Enabled \
		--profile $(PROFILE) >/dev/null )
	@echo "Bucket $(BUCKET_NAME) is ready and versioning is enabled (if it wasn't already)."

# Initialize Terraform
terraform-init: create-bucket
	@echo "Initializing Terraform with backend configuration..."
	cd terraform && terraform init
	@echo "Terraform initialized successfully."

# Build Lambda Layer
build-layer:
	@echo "Building Lambda layer from $(REQUIREMENTS_FILE)..."
	@if [ ! -f $(REQUIREMENTS_FILE) ]; then echo "Error: $(REQUIREMENTS_FILE) not found!" && exit 1; fi
	@rm -rf layers/custom_layer/python
	@mkdir -p layers/custom_layer/python
	@pip install -r $(REQUIREMENTS_FILE) -t layers/custom_layer/python/lib/python3.10/site-packages
	@echo "Lambda layer built successfully"

# Drop the S3 bucket even if it has contents
drop-bucket:
	@echo "Deleting all objects in bucket $(BUCKET_NAME)..."
	@aws s3 rm s3://$(BUCKET_NAME) --recursive --profile $(PROFILE) || true
	@echo "Deleting bucket $(BUCKET_NAME)..."
	@aws s3api delete-bucket --bucket $(BUCKET_NAME) --region $(AWS_REGION) --profile $(PROFILE)
	@echo "Bucket $(BUCKET_NAME) deleted."

# Clean built artifacts
clean:
	@echo "Cleaning up built artifacts..."
	@rm -rf layers/custom_layer $(LAYER_ZIP)
	@echo "Clean up complete."