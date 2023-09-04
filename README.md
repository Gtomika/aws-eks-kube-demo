# Spring Kubernetes demo app

Learning project to containerize a Spring Boot app and deploy 
it to Kubernetes. Two ways are provided to create a Kubernetes 
cluster:

 - *Minikube* (locally)
 - *AWS EKS* (cloud)

## How to run with Minikube

Create image from the application, will be placed into 
local Docker registry.

```
./gradlew bootBuildImage
```

Minikube must be installed. Start it and add image to it.

```
minikube start
minikube image load kube-demo:latest
```

On a **separate terminal**, simulate a load balancer. Keep this 
process running!

```
minikube tunnel
```

Return to original terminal. Apply Kubernetes
configurations while substituting image name.

```
export IMAGE_NAME=kube-demo:latest
envsubst < kube/app-deployment.yaml > kube/subst-app-deployment.yaml
kubectl apply -f kube/subst-app-deployment.yaml
kubectl apply -f kube/app-service.yaml
```

Following can be used to check if it's working

```
kubectl get pods
kubectl get service app-service
```

Pods should be `RUNNING` and the app should be available 
on `http://<EXTERNAL-IP>/api/app-id`. If `EXTERNAL-ID` is `<pending>`, 
make sure that the minikube tunnel process is successfully 
running in the separate terminal!

## How to run on AWS EKS

This process is automated using GitHub actions pipelines.

- [Infrastructure pipeline](.github/workflows/infra-pipeline.yaml): triggered when changes are made to `terraform`
directory (or manually). Plans and applies Terraform configuration, such as 
creating VPC and EKS cluster.
- [Deployment pipeline](.github/workflows/deployment-pipeline.yaml): triggered when changes made to `src` or `kube` 
directories (or manually). This pipeline runs tests, build Docker image, pushes it to ECR and 
finally: applies Kube config files to the cluster.
- [Infrastructure destroy pipeline](.github/workflows/infra-destroy-pipeline.yaml): triggered manually 
to tear down the infrastructure.

Provisioning the infrastructure takes around 10 minutes due to EKS 
cluster and nat gateways.

Due to EKS and Nat gateway costs, this setup can create a noticable AWS bill if 
left running. Therefore, infrastructure is destroyed (using appropriate pipeline) 
when this demo project is not used.