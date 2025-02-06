cd challenge-day2/backend/
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/o7s4h9d1/cloudmart/backend
docker build -t cloudmart-backend .
docker tag cloudmart-backend:latest public.ecr.aws/o7s4h9d1/cloudmart/backend:latest
docker push public.ecr.aws/o7s4h9d1/cloudmart/backend:latest
echo 'apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloudmart-backend-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cloudmart-backend-app
  template:
    metadata:
      labels:
        app: cloudmart-backend-app
    spec:
      serviceAccountName: cloudmart-pod-execution-role
      containers:
      - name: cloudmart-backend-app
        image: public.ecr.aws/o7s4h9d1/cloudmart/backend:latest
        env:
        - name: PORT
          value: "5000"
        - name: AWS_REGION
          value: "us-east-1"
        - name: BEDROCK_AGENT_ID
          value: "xxxxxx"
        - name: BEDROCK_AGENT_ALIAS_ID
          value: "xxxx"
        - name: OPENAI_API_KEY
          value: "xxxxxx"
        - name: OPENAI_ASSISTANT_ID
          value: "xxxx"
---

apiVersion: v1
kind: Service
metadata:
  name: cloudmart-backend-app-service
spec:
  type: LoadBalancer
  selector:
    app: cloudmart-backend-app
  ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000' > cloudmart-backend.yaml
kubectl apply -f cloudmart-backend.yaml
kubectl get pods
kubectl get deployment
kubectl get service
#apagar
kubectl delete service cloudmart-backend-app-service
kubectl delete deployment cloudmart-backend-app