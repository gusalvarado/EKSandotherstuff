import os
import requests
import json

OLLAMA_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")

def query_ollama(context_yaml: str, user_prompt: str, model="mistral") -> dict:
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": f"Context:\n{context_yaml}"},
            {"role": "user", "content": user_prompt}
        ],
        "stream": False
    }

    res = requests.post(f"{OLLAMA_URL}/api/chat", json=payload)
    content = res.json()["message"]["content"]

    try:
        return json.loads(content[content.find("{"):content.rfind("}")+1])
    except:
        return {"action": "unknown", "params": {}}