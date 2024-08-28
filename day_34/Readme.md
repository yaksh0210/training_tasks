# Project

## Deploying a Multi-Tier Application Using Helm on Kubernetes and AWS Free Tier Services

+ The use of Helm in Kubernetes with deploying and integrating free-tier AWS services. You will deploy a multi-tier application on Minikube using Helm, manage Helm charts, secrets, and RBAC, and integrate AWS services like S3 for storage and RDS (MySQL) for the database. The project will focus on versioning, packaging, rollback, and proper management of cloud resources.

## Project Objectives:

+ Deploy a multi-tier application using Helm on Minikube.
+ Integrate AWS free-tier services (S3 and RDS).
+ Manage Helm charts, including versioning, packaging, and rollbacks.
+ Implement Helm secrets management and RBAC.
+ Handle dependencies between different components of the application.

## Project Deliverables:

### 1. Setup Helm and Minikube

+ Ensure Minikube is running.

+ Install and configure Helm on the local machine.

### 2. AWS Services Setup

+ S3 Bucket: Create an S3 bucket for storing application assets (e.g., static files for the frontend).

+ First we will create bucket with

```sh
aws s3api create-bucket --bucket yaksh-bucket --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1
```

+ Then we will upload file using

```sh
aws s3 cp /path/to/static/files/ s3://yaksh-bucket/ --recursive
```

+ RDS Instance: Set up an Amazon RDS MySQL instance in the free tier.

```sh
aws rds create-db-instance \
    --db-instance-identifier mydbinstance \
    --allocated-storage 20 \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password root1234 \
    --backup-retention-period 7 \
    --availability-zone ap-south-1a \
    --no-multi-az \
    --engine-version 8.0 \
    --auto-minor-version-upgrade \
    --publicly-accessible \
    --storage-type gp2 \
    --db-name mydatabase \
    --region ap-south-1
```

<img src="./images/rds_create.png">

### 3. Create Helm Charts


+ Frontend Chart: Create a Helm chart for a frontend service (e.g., NGINX) that pulls static files from the S3 bucket.

```sh
helm create frontend
```

+ Add Value in frontend/values.yml

```yml
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: latest

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: true
  automount: true

annotations: {}
  name: ""

podAnnotations: {}
podLabels: {}

podSecurityContext: {}
# fsGroup: 2000

securityContext: {}
# capabilities:
#   drop:
#   - ALL
# readOnlyRootFilesystem: true
# runAsNonRoot: true
# runAsUser: 1000

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  className: ""
  annotations: {}
  # kubernetes.io/ingress.class: nginx
  # kubernetes.io/tls-acme: "true"
  hosts:
  - host: chart-example.local
    paths:
    - path: /
      pathType: ImplementationSpecific
  tls: []
  #  - secretName: chart-example-tls
  #    hosts:
  #      - chart-example.local

resources: {}
# We usually recommend not to specify default resources and to leave this as a conscious
# choice for the user. This also increases chances charts run on environments with little
# resources, such as Minikube. If you do want to specify resources, uncomment the following
# lines, adjust them as necessary, and remove the curly braces after 'resources:'.
# limits:
#   cpu: 100m
#   memory: 128Mi
# requests:
#   cpu: 100m
#   memory: 128Mi

livenessProbe:
  httpGet:
    path: /
    port: http
readinessProbe:
  httpGet:
    path: /
    port: http

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
  # targetMemoryUtilizationPercentage: 80

# Additional volumes on the output Deployment definition.
volumes: []
# - name: foo
#   secret:
#     secretName: mysecret
#     optional: false

# Additional volumeMounts on the output Deployment definition.
volumeMounts: []
# - name: foo
#   mountPath: "/etc/foo"
#   readOnly: true

nodeSelector: {}

tolerations: []

affinity: {}

files:
  staticUrl: "https://yaksh-bucket.s3.ap-south-1.amazonaws.com"
```

+ Backend Chart: Create a Helm chart for a backend service (e.g., a Python Flask API) that connects to the RDS MySQL database.

```sh
helm create backend
```

+ For backend/values.yml


```yml
# Default values for backend.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

image:
  repository: fansari9993/test9
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: tagname

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # Automatically mount a ServiceAccount's API credentials?
  automount: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ""

podAnnotations: {}
podLabels: {}

podSecurityContext: {}
# fsGroup: 2000

securityContext: {}

service:
  type: ClusterIP
  port: 5000

ingress:
  enabled: false
  className: ""
  annotations: {}

hosts:
  - host: chart-example.local
    paths:
    - path: /
      pathType: ImplementationSpecific
  tls: []

resources: {}

livenessProbe:
  httpGet:
    path: /
    port: http
readinessProbe:
  httpGet:
    path: /
    port: http

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80

volumes: []

volumeMounts: []

nodeSelector: {}

tolerations: []

affinity: {}

database:
  host: "mydbinstance.cxqq6ia24yor.ap-south-1.rds.amazonaws.com"
  name: "mydbinstance"
  user: "admin"
  password: "root1234"
  port: 3306

```

### 4. Package Helm Charts

+ Package each Helm chart into a .tgz file.

```sh
cd frontend/
helm package .
mv frontend-0.1.0.tgz ../
```

```sh

```sh
cd backend/
helm package .
mv backend-0.1.0.tgz ../
```

+ Ensure charts are properly versioned.

<img src="./images/pkg_frontens.png">

<br>

<img src="./images/pkg_backend.png">

<br>

### 5. Deploy Multi-Tier Application Using Helm

+ Deploy the database chart (connected to the RDS instance).

+ Deploy the backend chart with dependency on the database chart.

+ Deploy the frontend chart with dependency on the backend service, ensuring it pulls assets from the S3 bucket.

```sh
helm install frontend ./frontend-0.1.0.tgz
```

```sh
helm install backend ./backend-0.1.0.tgz
```

<img src="./images/inst_frontend.png">

<br>

<img src="./images/inst_frontend.png">

### 6. Manage Helm Secrets

+ Implement Helm secrets for managing sensitive data such as database credentials and S3 access keys.

```
helm plugin install https://github.com/jkroepke/helm-secrets
```

+ Update the backend chart to use these secrets for connecting to the RDS instance and S3.

+ Secrets.yml

```yml
database:
  password: "root1233"
aws:
  access_key: "your-access-key"
  secret_key: "your-secret-key"
```


### 7. Implement RBAC

+ Define RBAC roles and role bindings to manage permissions for Helm deployments.

+ Ensure that only authorized users can deploy or modify the Helm releases.

+ rbac.yml


```yml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: helm-role
rules:
- apiGroups: ["", "apps", "extensions"]
  resources: ["pods", "deployments", "services", "secrets", "configmaps"]
  verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: helm-rolebinding
  namespace: default
subjects:
- kind: User
  name: helm-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: helm-role
  apiGroup: rbac.authorization.k8s.io
```

+ Then run

```sh
kubectl apply -f rbac.yaml
```
<img src="./images/role.png">

### 8. Versioning and Rollback

+ Update the version of one of the Helm charts (e.g., update the frontend service).


<img src="./images/upgrade_frontend.png">

+ Perform a rollback if necessary and validate the application functionality.

<img src="./images/rollback_frontend.png">

### 9. Validate Deployment

+ Ensure the frontend service is serving files from the S3 bucket.

<img src="./images/bucket.png">

+ Validate that the backend service is successfully communicating with the RDS MySQL database.

<img src="./images/rds_create.png">

### 10. Cleanup

+ Delete all Helm releases and Kubernetes resources created during the project.

+ Terminate the RDS instance and delete the S3 bucket.

+ Stop Minikube if no longer needed.

```sh
helm uninstall frontend
helm uninstall backend
aws s3 rm s3://your-bucket-name/ --recursive
aws rds delete-db-instance --db-instance-identifier mydbinstance --skip-final-snapshot
minikube stop
minikube delete
```