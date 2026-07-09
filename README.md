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

## Lancer Flutter

```powershell
cd flutter_app
flutter pub get
flutter run
```

Pour un emulateur Android, l'application utilise `http://10.0.2.2:5000`.
Pour Windows, web ou iOS simulator, il faudra remplacer `baseUrl` dans
`flutter_app/lib/services/api_service.dart` par `http://localhost:5000`.
