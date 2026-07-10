# Rapport final - SellCatalog

## Architecture

Le projet est compose d'un backend Python Flask et d'une application Flutter.
Les deux parties communiquent avec une API REST.

Le backend se trouve dans `server/`. Il expose les routes de connexion,
d'inscription et de consultation des produits. Les donnees sont stockees dans
des fichiers JSON.

L'application Flutter se trouve dans `flutter_app/`. Elle est organisee avec :

- `models/` pour les objets de donnees.
- `services/` pour les appels API, la session et les favoris.
- `screens/` pour les ecrans de l'application.

## Fonctionnalites realisees

- Connexion utilisateur.
- Inscription utilisateur.
- Sauvegarde locale de la session.
- Redirection automatique si une session existe.
- Deconnexion.
- Liste des produits depuis l'API.
- Detail produit.
- Recherche par titre ou description.
- Filtre par categorie.
- Ajout et retrait de favoris.
- Filtre favoris uniquement.
- Theme rouge/blanc avec Material 3.
- Police Poppins appliquee globalement.
- Image de fond et logo personnalisables.

## Fonctionnement utilisateur

L'utilisateur ouvre l'application. Si aucune session n'existe, il arrive sur la
connexion. Il peut se connecter avec un compte existant ou creer un nouveau
compte.

Apres connexion ou inscription, il arrive sur le catalogue. Il peut rechercher
un produit, choisir une categorie, afficher uniquement les favoris, ouvrir le
detail d'un produit et modifier ses favoris.

La deconnexion supprime la session locale et renvoie vers l'ecran de connexion.

## Verification

Les commandes suivantes ont ete executees :

```powershell
flutter analyze
flutter test
python -m compileall server
```

Les routes backend ont aussi ete testees :

- `POST /api/login`
- `POST /api/register`
- `GET /api/produits`
- `GET /api/produits/<id>`
