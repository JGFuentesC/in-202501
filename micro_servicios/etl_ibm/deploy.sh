#!/bin/bash

# Variables
PROJECT_ID="bi-2025-01"
REGION="us-central1"
SERVICE_NAME="etl-ibm"
BUCKET_NAME="cubetitabi"
ENTRY_POINT="main"
RUNTIME="python311" 
SOURCE_DIR="."

# Deploy the Cloud Run function
gcloud functions deploy $SERVICE_NAME \
    --gen2 \
    --region=$REGION \
    --runtime=$RUNTIME \
    --source=$SOURCE_DIR \
    --entry-point=$ENTRY_POINT \
    --trigger-event=google.storage.object.finalize \
    --trigger-resource=$BUCKET_NAME \
    --project=$PROJECT_ID \
    --memory=512MB \
    --cpu=1 \
    --min-instances=0 \
    --max-instances=2

echo "Deployment completed."