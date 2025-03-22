import os

def restart_failed_pods():
    os.system("kubectl get pods --field-selector=status.phase=Failed -o name | xargs -r kubectl delete")

def apply_terraform():
    os.system("terraform init && terraform apply -auto-approve")