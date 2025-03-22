import os

def trigger_pipeline(repo, branch="main"):
    os.system(f"gh workflow run deploy.yml -R {repo} -b {branch}")