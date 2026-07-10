# Rapport court - SellCatalog

## Architecture

Le projet est separe en deux parties independantes. Le dossier `server/`
contient un backend Python Flask qui expose une API REST simple. Les donnees
sont stockees dans deux fichiers JSON : `users.json` pour les utilisateurs et
`ventes.json` pour le catalogue.

Le dossier `flutter_app/` contient l'application cliente Flutter. Le code est
organise en `models/`, `services/` et `screens/`. Les services gerent les appels
HTTP et la session locale, les modeles representent les donnees, et les ecrans
gerent le parcours utilisateur.

## Fonctionnement

L'utilisateur arrive sur l'ecran de connexion. Le formulaire valide l'email et
le mot de passe, puis appelle `POST /api/login`. En cas de succes, les
informations utilisateur sont sauvegardees avec `shared_preferences`.

Au demarrage, l'application verifie si une session existe deja. Si oui,
l'utilisateur est redirige directement vers la liste des produits. Sinon, il
reste sur l'ecran de connexion. La liste appelle `GET /api/produits`, affiche
les produits avec image, titre, categorie et prix, puis permet d'ouvrir un ecran
de detail.

## Difficultes rencontrees

La principale difficulte concerne l'adresse du serveur selon la plateforme. Sur
Windows, web et simulateur iOS, `localhost:5000` fonctionne. Sur emulateur
Android, il faut utiliser `10.0.2.2:5000`.

Une autre attention importante concerne la lisibilite de l'ecran de connexion :
comme l'image est en arriere-plan, un voile sombre est ajoute pour garder les
champs et les messages visibles.

## Limites de securite

Les mots de passe sont stockes en clair dans `users.json`, uniquement pour le
cadre pedagogique du devoir. Dans une vraie application, il faudrait hasher les
mots de passe, utiliser HTTPS, ajouter des tokens d'authentification et mieux
proteger les donnees locales.

La session locale stocke les informations utilisateur avec `shared_preferences`.
C'est suffisant pour ce mini-projet, mais une application de production devrait
utiliser un mecanisme plus robuste pour les donnees sensibles.

## Verification

Les tests Flutter passent avec `flutter test`, l'analyse statique passe avec
`flutter analyze`, et les routes principales du serveur ont ete testees sur
`http://localhost:5000`.
