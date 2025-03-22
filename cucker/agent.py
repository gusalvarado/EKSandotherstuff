from flask import Flask, request, render_template
import requests, os, json

app = Flask(__name__)
OLLAMA_URL = os.getenv('OLLAMA_URL', 'http://ollama:11434')
OLLAMA_MODEL = os.getenv('OLLAMA_MODEL', 'mistral')


def get_recipe(ingredients):
    prompt = f"""Give me a recipe with the next {ingredients}
    {{
        "title": "",
        "description": "",
        "ingredients": [""],
        "steps": [""]
    }}
    """

    payload = {
        "model": OLLAMA_MODEL,
        "messages": [
            {"role": "system", "content": "You are a helpful chef assistant."},
            {"role": "user", "content": prompt}
        ],
        "stream": False
    }
    response = requests.post(f"{OLLAMA_URL}/api/chat", json=payload)

    content = response.json()["message"]["content"]
    try:
        start = content.find("{")
        end = content.rfind("}") + 1
        return json.loads(content[start:end])
    except:
        return content

@app.route("/", methods=["GET", "POST"])
def index():
    recipe = None
    if request.method == "POST":
        ingredients = request.form["ingredients"]
        recipe = get_recipe(ingredients)
    return render_template("index.html", recipe=recipe)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)