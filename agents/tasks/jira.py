import requests

def create_ticket(ctx, summary, description, priority="Medium"):
    url = f"{ctx['base_url']}/rest/api/3/issue"
    headers = {
        "Authorization": f"Basic {ctx['api_token']}",
        "Content-Type": "application/json"
    }
    payload = {
        "fields": {
            "project": {"key": ctx["project_key"]},
            "summary": summary,
            "description": description,
            "issuetype": {"name": "Bug"},
            "priority": {"name": priority}
        }
    }
    res = requests.post(url, headers=headers, json=payload)
    return res.json()["key"] if res.ok else None