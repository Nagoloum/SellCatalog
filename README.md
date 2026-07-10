# SellCatalog

SellCatalog est une application Flutter avec un backend Python Flask. Elle
permet de se connecter, de s'inscrire, de consulter un catalogue de ventes
privees, de rechercher des produits, de filtrer par categorie et de gerer des
favoris persistants.

## Stack technique

- Flutter : application cliente mobile/desktop/web.
- Dart : langage utilise par Flutter.
- Material 3 : theme visuel de l'application.
- Python : langage du backend.
- Flask : framework HTTP du backend.
- JSON : stockage simple des utilisateurs et des produits.
- http : appels API cote Flutter.
- shared_preferences : session locale et favoris.

## Structure du projet

```text
SellCatalog/
+-- server/
|   +-- data/
|   |   +-- users.json
|   |   +-- ventes.json
|   +-- requirements.txt
|   +-- server.py
+-- flutter_app/
|   +-- assets/
|   |   +-- fonts/
|   |   +-- images/
|   +-- lib/
|   |   +-- models/
|   |   +-- screens/
|   |   +-- services/
|   |   +-- main.dart
|   +-- pubspec.yaml
+-- docs/
|   +-- CAPTURES.md
|   +-- RAPPORT.md
|   +-- TASKS.md
+-- explication.md
+-- README.md
```

## Installation du backend

Depuis la racine du projet :

```powershell
cd server
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python server.py
```

Le serveur demarre sur :

```text
http://localhost:5000
```

## Installation de l'application Flutter

Dans un autre terminal :

```powershell
cd flutter_app
flutter pub get
flutter run
```

L'application utilise actuellement :

```dart
static const String baseUrl = 'http://localhost:5000';
```

Ce reglage est dans :

```text
flutter_app/lib/services/api_service.dart
```

Pour un emulateur Android, remplacer temporairement par :

```dart
static const String baseUrl = 'http://10.0.2.2:5000';
```

## Identifiants de test

```text
Email: sophie.martin@example.com
Mot de passe: azerty123

Email: karim.benali@example.com
Mot de passe: motdepasse2
```

Il est aussi possible de creer un nouveau compte depuis l'ecran
`Inscription`.

## Fonctionnement de l'application

Au lancement, l'application verifie si une session existe deja en local. Si une
session existe, l'utilisateur arrive directement sur la liste des produits. Si
aucune session n'existe, l'ecran de connexion est affiche.

Apres connexion ou inscription, l'utilisateur arrive sur la page des ventes
privees. Cette page charge les produits depuis l'API Python, affiche l'image, le
titre, la categorie et le prix. L'utilisateur peut rechercher un produit, filtrer
par categorie et afficher uniquement les favoris.

Chaque produit peut etre ajoute ou retire des favoris depuis la liste ou depuis
l'ecran de detail. Les favoris sont gardes en local avec `shared_preferences`.

Le bouton de deconnexion supprime la session locale et renvoie vers la page de
connexion.

## API backend

### POST `/api/login`

Connecte un utilisateur.

```json
{
  "email": "sophie.martin@example.com",
  "password": "azerty123"
}
```

### POST `/api/register`

Cree un utilisateur.

```json
{
  "prenom": "Nora",
  "nom": "Diallo",
  "email": "nora.diallo@example.com",
  "password": "test1234"
}
```

### GET `/api/produits`

Renvoie la liste complete des produits.

### GET `/api/produits/<id>`

Renvoie le detail d'un produit.

## Verification

Backend :

```powershell
python -m compileall server
```

Flutter :

```powershell
cd flutter_app
flutter analyze
flutter test
```

## Images et personnalisation

Les images de l'application sont dans :

```text
flutter_app/assets/images/
```

Images utilisees par la page de connexion et d'inscription :

```text
flutter_app/assets/images/backgoundimg.jpg
flutter_app/assets/images/logo.png
```

La police Poppins est dans :

```text
flutter_app/assets/fonts/
```

## Rapport final global

Fonctionnalites realisees :

- Backend Python Flask avec routes REST.
- Donnees utilisateurs dans `users.json`.
- Catalogue produits dans `ventes.json`.
- Connexion avec email et mot de passe.
- Inscription depuis l'application.
- Session locale persistante.
- Redirection automatique si l'utilisateur est deja connecte.
- Deconnexion avec nettoyage de la session.
- Liste des produits chargee depuis l'API.
- Detail produit complet.
- Recherche par titre ou description.
- Filtre par categorie.
- Filtre favoris uniquement.
- Favoris persistants en local.
- Theme rouge/blanc en Material 3.
- Police Poppins globale.
- Image de fond personnalisable sur connexion et inscription.
- Documentation du projet et explication pedagogique.
