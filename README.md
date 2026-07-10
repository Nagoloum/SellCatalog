# SellCatalog

Mini-projet Flutter + backend Python pour un catalogue de ventes privees.

## Structure

```text
SellCatalog/
+-- server/
|   +-- data/
|   |   +-- users.json
|   |   +-- ventes.json
|   +-- requirements.txt
|   +-- server.py
+-- flutter_app/
|   +-- lib/
|   |   +-- models/
|   |   +-- screens/
|   |   +-- services/
|   |   +-- main.dart
|   +-- pubspec.yaml
+-- docs/
```

## Lancer le serveur

```powershell
cd server
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python server.py
```

API disponible sur `http://localhost:5000`.

## Identifiants de test

```text
Email: sophie.martin@example.com
Mot de passe: azerty123

Email: karim.benali@example.com
Mot de passe: motdepasse2
```

## API backend

### POST `/api/login`

Connecte un utilisateur avec son email et son mot de passe.

Requete :

```json
{
  "email": "sophie.martin@example.com",
  "password": "azerty123"
}
```

Reponse `200` :

```json
{
  "id": 1,
  "email": "sophie.martin@example.com",
  "nom": "Martin",
  "prenom": "Sophie"
}
```

Le mot de passe n'est jamais renvoye par cette route.

Reponse `401` :

```json
{
  "message": "Identifiants invalides"
}
```

### GET `/api/produits`

Renvoie la liste complete des produits.

### GET `/api/produits/<id>`

Renvoie le detail d'un produit.

Reponse `404` si le produit n'existe pas :

```json
{
  "message": "Produit introuvable"
}
```

## Lancer Flutter

```powershell
cd flutter_app
flutter pub get
flutter run
```

Par defaut, l'application utilise `http://localhost:5000` dans
`flutter_app/lib/services/api_service.dart`, ce qui convient pour Windows,
web et iOS simulator.

Pour un emulateur Android, remplacez temporairement `baseUrl` par :

```dart
static const String baseUrl = 'http://10.0.2.2:5000';
```

## Verification rapide

```powershell
cd flutter_app
flutter analyze
flutter test
```

Le serveur a ete teste localement sur `http://localhost:5000` avec :

- login valide
- login invalide en `401`
- liste des produits
- detail produit
- produit introuvable en `404`
