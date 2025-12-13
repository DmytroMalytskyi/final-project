from flask import Flask, jsonify, request
import socket, os

app = Flask(__name__)

@app.route("/", methods=["GET"])
def root():
    pod_ip = socket.gethostbyname(socket.gethostname())
    return jsonify(
        status="ok",
        message="Hello from Python backend on EKS via NGINX Ingress",
        pod_ip=pod_ip,
        client_ip=request.headers.get("x-forwarded-for", request.remote_addr)
    ), 200

@app.route("/healthz", methods=["GET"])
def healthz():
    return "ok", 200

if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
