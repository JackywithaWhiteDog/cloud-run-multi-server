"""Flask server for push subscription"""
import os

from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello World!'


if __name__ == "__main__":
    PORT = int(os.getenv("PORT")) if os.getenv("PORT") else 8080
    app.run(host="127.0.0.1", port=PORT, debug=True)
