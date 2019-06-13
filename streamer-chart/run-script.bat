helm install stable/nginx-ingress --name ingress
helm install --name streamer ./
helm install stable/heapster --name heapster
helm install stable/metrics-server --name metrics-server
