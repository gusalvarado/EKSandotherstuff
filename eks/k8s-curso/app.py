from flask import Flask, send_file, jsonify
from kubernetes import client, config
import os
app = Flask(__name__)
@app.route("/")
def home():
    secret_value = os.getenv("SECRET_KEY", "default_secret")
    config_value = os.getenv("CONFIG_VALUE", "default_config")
    return f"""
<html>
    <head>
        <title>Register new excercise </title>
        <style>
            body {{
                text-align: center;
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #245DEC, #9F5EFF);
                color: white;
                height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }}
            .container {{
                background: rgba(255, 255, 255, 0.1);
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 0 15px rgba(255, 255, 255, 0.2);
            }}
            h1 {{
                font-size: 50px;
                font-weight: bold;
                text-shadow: 3px 3px 5px rgba(0, 0, 0, 0.3);
                color: #ffffff;
            }}
            h2 {{
                font-size: 28px;
                margin: 10px 0;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
                color: #ffffff;
            }}
            .highlight {{
                color: black;  /* Letras negras */
                font-weight: bold;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Hello from <span class="highlight">Python App!</span></h1>
            <h2>Secret: <span class="highlight">{secret_value}</span></h2>
            <h2>Config: <span class="highlight">{config_value}</span></h2>
        </div>
    </body>
</html>
"""
@app.route("/image")
def get_image():
    image_path = "/images/uploaded_image.jpg"  # Ruta esperada en el volumen
    if os.path.exists(image_path):
        return send_file(image_path, mimetype="image/jpeg")
    else:
        return "No image found", 404
# Cargar configuración dentro del clúster
# config.load_incluster_config()
# @app.route("/pods")
# def list_pods():
#   v1 = client.CoreV1Api()
#   pods = v1.list_namespaced_pod(namespace="default")
#   return jsonify([pod.metadata.name for pod in pods.items])
# @app.route("/services")
# def list_services():
#     v1 = client.CoreV1Api()
#     services = v1.list_namespaced_service(namespace="default")
#     # Extraer nombres y direcciones de los servicios
#     service_list = [
#         {
#             "name": svc.metadata.name,
#             "cluster_ip": svc.spec.cluster_ip,
#             "ports": [{"port": p.port, "protocol": p.protocol} for p in svc.spec.ports]
#         }
#         for svc in services.items
#     ]
#     return jsonify(service_list)
# @app.route("/secrets")
# def list_secrets():
#     v1 = client.CoreV1Api()
#     secrets = v1.list_namespaced_secret(namespace="default")
#     secret_names = [secret.metadata.name for secret in secrets.items]
#     return jsonify({"secrets": secret_names})
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
