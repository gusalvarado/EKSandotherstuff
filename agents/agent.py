from flask import Flask, request, render_template
from tasks import jira, pipeline, infra
import yaml, requests

from utils.llm_ollama import query_ollama

app = Flask(__name__)

# Load context from YAML
with open("config/context.yml") as f:
    ctx = yaml.safe_load(f)["contexts"]

def handle_prompt_with_ollama(user_input):
    result = query_ollama(yaml.dump(ctx), user_input)
    action = result.get("action")
    params = result.get("params", {})

    if action == "jira_status":
        return jira.get_status(ctx["jira"], params.get("ticket_id", ""))
    elif action == "restart_pods":
        return infra.restart_failed_pods()
    elif action == "deploy":
        return pipeline.trigger_pipeline(ctx["pipeline"]["repo"])
    elif action == "apply_terraform":
        return infra.apply_terraform()
    else:
        return "🤖 Sorry, I didn’t understand that command."

@app.route("/", methods=["GET", "POST"])
def prompt():
    response = ""
    if request.method == "POST":
        query = request.form["query"].lower()

        # Example basic NLP
        if "jira" in query and "status" in query:
            ticket_id = query.split()[-1].upper()
            response = f"Jira Status for {ticket_id}: " + jira.get_status(ctx["jira"], ticket_id)

        elif "deploy" in query and "staging" in query:
            pipeline.trigger_pipeline(ctx["pipeline"]["repo"])
            response = "Triggered staging deployment via GitHub Actions."

        elif "restart pods" in query:
            infra.restart_failed_pods()
            response = "Restarted failed Kubernetes pods."

        else:
            response = "🤖 I didn’t understand that command."

    return render_template("index.html", response=response)

@app.route("/status")
def status():
    try:
        r = requests.get("http://ollama:11434")
        return "🟢 Ollama is online" if r.status_code == 200 else "🟠 Unexpected response"
    except:
        return "🔴 Ollama not reachable"

@app.route("/show")
def show():
    try:
        r = requests.post("http://ollama:11434/api/show"),
        json={"name": "context"}
        return r.text
    except:
        return "🔴 Error", r.text


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)