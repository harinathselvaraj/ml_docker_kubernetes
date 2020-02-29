# Setup Virtual Environment
-- Go inside project folder
virtualenv virt
source virt/bin/activate
pip install flask==1.0.2 requests flask_restful numpy pandas
pip install lightgbm
pip freeze > requirements.txt

# Running the Application
python app.py

# HTTP Server - gunicorn - Multiple workers
https://gunicorn.org/
http://docs.gunicorn.org/en/stable/design.html#how-many-workers
DO NOT scale the number of workers to the number of clients you expect to have. Gunicorn should only need 4-12 worker processes to handle hundreds or thousands of requests per second

gunicorn --bind 0.0.0.0:5000 "app:application()"
-- app is app.py. :application is the main program name inside the file

# Dockerize it
Update the Dockerfile 
   - point to app.py
   - instruct to install all libraries in requirements.txt

## Building first
Issue: Pandas is installing for a long time in docker
** come out of virtualenv
** Delete the 'virt' folder... Use dockerignore file instead of this.

docker build -t lightgbm_docker:1.01 .
docker images
docker run -d -p 8000:8000 lightgbm_docker:1.01
docker ps -a

Docker logs - ## Helped me when there was errors.
docker container logs --follow <id>




## Kill docker container
docker stop 01ebad057715
docker rm 01ebad057715

## Making changes and redeploying
- do the same process again

## Tag & Push the docker
docker tag firstpythonserver <docker_hub_url>/firstpythonserver:1.00
docker push <docker_hub_url>/firstpythonserver:1.00

# Kubernetes 
## Google Kubernetes Engine (GKE)
Container Registry
https://towardsdatascience.com/devops-for-data-science-with-gcp-3e6b5c3dd4f6
1. GCP Development Environment

Step 1 - Setup New Project
   https://console.cloud.google.com/projectcreate?previousPage=%2Fgcr%2Fsettings&project=&folder=&organizationId=0
   Project Name - mlprojects
   Project ID - mlprojects-269222

Step 2 - Install gcloud CLI on Mac
https://cloud.google.com/sdk/docs/quickstart-macos
It is downloaded in Downloads

cd Downloads/google-cloud-sdk
./install.sh

Step 3 - Credentials for programmatically accessing the projects
   gcloud config set project mlprojects-269222
   gcloud auth login
   gcloud init
   gcloud iam service-accounts create mlprojects
   gcloud projects add-iam-policy-binding mlprojects-269222 --member "serviceAccount:mlprojects@mlprojects-269222.iam.gserviceaccount.com" --role "roles/owner"
   gcloud iam service-accounts keys create creds.json --iam-account mlprojects@mlprojects-269222.iam.gserviceaccount.com

-- Output
created key [23a3154080d2e50988157e8a7426f57b31d86193] of type [json] as [creds.json] for [mlprojects@mlprojects-269222.iam.gserviceaccount.com]

-- Change project by typing this ---> gcloud config set project PROJECT_ID

### Use the credentials and push the image from local to Google Container Registry
cat creds.json | sudo docker login -u _json_key --password-stdin https://eu.gcr.io
sudo docker tag lightgbm_docker:1.00 eu.gcr.io/mlprojects-269222/lightgbm_docker:1.00 
sudo docker push eu.gcr.io/mlprojects-269222/lightgbm_docker:1.00

https://us.gcr.io hosts for US Images
[gcp_account] google account ID
More details - https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=en_US&_ga=2.36420896.-1277834788.1580766497#pushing_an_image_to_a_registry

https://medium.com/engineered-publicis-sapient/productionizing-ml-model-prediction-web-api-on-kubernetes-4dfcbae2f498

### Kubernetes Engine
Search for and select “Kubernetes Engine”
Click “Deploy Container”
Select “Existing Container Image”
Choose “lightgbm_docker:1.00”
Assign an application name “lightgbm-kge”
Click “Deploy”

Deployment in GKE (Google Kubernetes Engine) - https://vimeo.com/394156365

## Amazon ECS (Elastic Container Service)

Yet to do