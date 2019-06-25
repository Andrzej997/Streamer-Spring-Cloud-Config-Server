Rem change cluster-name in aws-spec-template/alb-ingress-controller.yaml
kubectl apply -f .\aws-scripts\aws-auth-cm.yaml
aws eks --region eu-west-1 update-kubeconfig --name streamer-cluster
kubectl apply -f ./aws-spec-template/tiller-rbac.yml
helm init --service-account tiller
aws iam list-instance-profiles
pause
Rem look https://akomljen.com/integrating-aws-iam-and-kubernetes-with-kube2iam/
Rem look https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.2/docs/examples/iam-policy.json
Rem look https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/walkthrough/echoserver/
helm install --name iam --namespace kube-system -f /role-policies/values-kube2iam.yml stable/kube2iam
aws iam put-role-policy --role-name streamer-cluster-stack-NodeInstanceRole-1OQ9V27A4RQRK --policy-name kube2iam --policy-document file:///role-policies/kube2iam-policy.json
aws iam put-role-policy --role-name streamer-cluster-stack-NodeInstanceRole-1OQ9V27A4RQRK --policy-name ingress-default-policy --policy-document file:///role-policies/ingress-default-policy.json
aws iam create-role --role-name aws-trust-role --assume-role-policy-document file:///role-policies/alb-trust-role.json
aws iam put-role-policy --role-name aws-trust-role --policy-name ingress-kube2iam --policy-document file:///role-policies/alb-role-policy.json
aws iam put-role-policy --role-name aws-trust-role --policy-name ingress-default-policy --policy-document file:///role-policies/ingress-default-policy.json
pause
Rem copy arn from new role and put it in ingress-controller.yml
kubectl apply -f ./aws-spec-template/alb-ingress-rbac.yml
kubectl apply -f ./aws-spec-template/alb-ingress-controller.yaml
kubectl apply -f ./aws-spec-template/kubernetes-dashboard.yml
helm install --name edm ./
helm install stable/heapster --name heapster
helm install stable/metrics-server --name metrics-server
