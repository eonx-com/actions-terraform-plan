#!/bin/sh

# ----------------------------------------------------------------------------------------------------------------------------------
# Setup AWS credentials from the Github Actions values
# ----------------------------------------------------------------------------------------------------------------------------------

export AWS_ACCESS_KEY_ID="${INPUT_AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${INPUT_AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="${INPUT_AWS_DEFAULT_REGION}"
export SUMOLOGIC_ACCESSID="${INPUT_SUMO_LOGIC_ACCESS_ID}"
export SUMOLOGIC_ACCESSKEY="${INPUT_SUMO_LOGIC_ACCESS_KEY}"
export SUMOLOGIC_ENVIRONMENT="${INPUT_SUMO_LOGIC_ENVIRONMENT}"

# ----------------------------------------------------------------------------------------------------------------------------------
# Deploy Project Infrastructure
# ----------------------------------------------------------------------------------------------------------------------------------

# Change into the directory indicated in the Github Actions variable
cd "${GITHUB_WORKSPACE}" || exit 1
cd "${INPUT_PATH}" || exit 2

# Search for Terraform backend definition
if [ -f "devops.tf" ]; then
  echo
  echo
  echo
  cat devops.tf
  # Begin deployment
  echo
  echo
  echo "Running Terraform init"
  terraform init || exit 3
  echo
  echo
  echo "Running Terraform plan"
  TF_VAR_sumologic_access_id="${INPUT_SUMO_LOGIC_ACCESS_ID}" TF_VAR_sumologic_access_key="${INPUT_SUMO_LOGIC_ACCESS_KEY}" TF_VAR_sumologic_access_key="${INPUT_SUMO_LOGIC_ENVIRONMENT}" terraform plan ${INPUT_APPLY_PARAMETERS} || exit 4
else
  # Failed to locate Terraform backend definition
  echo "ERROR: Could not locate expected Terraform backend definition file ('devops_backend.tf') in the specified folder"
  exit 5
fi
