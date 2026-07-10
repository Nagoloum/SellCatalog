from __future__ import annotations

import json
from pathlib import Path

from flask import Flask, jsonify, request
from flask_cors import CORS


BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "data"

app = Flask(__name__)
CORS(app)


def load_json(filename: str) -> list[dict]:
    with (DATA_DIR / filename).open(encoding="utf-8") as file:
        return json.load(file)


def save_json(filename: str, data: list[dict]) -> None:
    with (DATA_DIR / filename).open("w", encoding="utf-8") as file:
        json.dump(data, file, ensure_ascii=False, indent=2)
        file.write("\n")


def public_user(user: dict) -> dict:
    return {key: value for key, value in user.items() if key != "password"}


@app.post("/api/login")
def login():
    payload = request.get_json(silent=True) or {}
    email = payload.get("email", "").strip().lower()
    password = payload.get("password", "")

    users = load_json("users.json")
    user = next(
        (
            current_user
            for current_user in users
            if current_user["email"].lower() == email
            and current_user["password"] == password
        ),
        None,
    )

    if user is None:
        return jsonify({"message": "Identifiants invalides"}), 401

    return jsonify(public_user(user))


@app.post("/api/register")
def register():
    payload = request.get_json(silent=True) or {}
    email = payload.get("email", "").strip().lower()
    password = payload.get("password", "")
    nom = payload.get("nom", "").strip()
    prenom = payload.get("prenom", "").strip()

    if not email or not password or not nom or not prenom:
        return jsonify({"message": "Tous les champs sont obligatoires"}), 400

    users = load_json("users.json")
    email_exists = any(user["email"].lower() == email for user in users)

    if email_exists:
        return jsonify({"message": "Cet email est deja utilise"}), 409

    next_id = max((user["id"] for user in users), default=0) + 1
    user = {
        "id": next_id,
        "email": email,
        "password": password,
        "nom": nom,
        "prenom": prenom,
    }

    users.append(user)
    save_json("users.json", users)

    return jsonify(public_user(user)), 201


@app.get("/api/produits")
def products():
    return jsonify(load_json("ventes.json"))


@app.get("/api/produits/<int:product_id>")
def product_detail(product_id: int):
    products_data = load_json("ventes.json")
    product = next(
        (
            current_product
            for current_product in products_data
            if current_product["id"] == product_id
        ),
        None,
    )

    if product is None:
        return jsonify({"message": "Produit introuvable"}), 404

    return jsonify(product)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
