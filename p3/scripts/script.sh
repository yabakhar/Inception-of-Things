sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo k3d cluster create my-cluster -p 8888:80@loadbalancer --agents 2
sudo wget https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.1/manifests/install.yaml
sudo sed -i '2743 i \        - --insecure' install.yaml
sudo sed -i '2744 i \        - --rootpath' install.yaml
sudo sed -i '2745 i \        - /argocd' install.yaml
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl apply -f install.yaml -n argocd
sudo kubectl apply -f ../confs/ingress.yaml -n argocd
sudo kubectl apply -f ../confs/application.yaml -n argocd
sudo kubectl -n argocd patch secret argocd-secret -p '{"stringData": { "admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6", "admin.passwordMtime": "'$(date +%FT%T%Z)'" }}'
