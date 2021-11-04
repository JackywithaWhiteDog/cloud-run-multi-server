# Cloud Run Multi-Server

This is a sample code to deploy multiple servers into Cloud Run.

## Prerequisites

- Permission to deploy Cloud Run service
- Setting Application Default Credentials
- `gcloud` SDK

## Typical Usage

Builds the image

```shell
gcloud builds submit --tag=gcr.io/[PROJECT_ID]/[IMAGE_NAME]
```

Deploy to Cloud Run

```shell
gcloud run deploy [SERVICE_NAME] \
    --region=[REGION] \
    --image=gcr.io/[PROJECT_ID]/[IMAGE_NAME] \
    --no-allow-unauthenticated
```
