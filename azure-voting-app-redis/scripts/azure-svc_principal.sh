#!/bin/bash

ACR_NAME=rleastusacr
SERVICE_PRINCIPAL_NAME=rleastusacr-sp1

# Populate the ACR login server and resource id.
ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query loginServer --output tsv)
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Show defined variables
echo "ACR_NAME=$ACR_NAME"
echo "SERVICE_PRINCIPAL_NAME=$SERVICE_PRINCIPAL_NAME"
echo "ACR_LOGIN_SERVER=$ACR_LOGIN_SERVER"
echo "ACR_REGISTRY_ID=$ACR_REGISTRY_ID"
echo "------------------------------------------------------------------------"

# Create a 'Reader' role assignment with a scope of the ACR resource.
SP_PASSWD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --role Reader --scopes $ACR_REGISTRY_ID --query password --output tsv)

# Get the service principal client id.
CLIENT_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Output used when creating Kubernetes secret.
echo "Service principal ID: $CLIENT_ID"
echo "Service principal password: $SP_PASSWD"
