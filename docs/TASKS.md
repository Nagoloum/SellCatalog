# Plan des taches

## 1. Initialisation du projet

- [x] Creer l'architecture `server/` et `flutter_app/`.
- [x] Initialiser le projet Flutter.
- [x] Ajouter les dependances Flutter `http` et `shared_preferences`.
- [x] Activer Material 3 avec `useMaterial3: true`.
- [x] Configurer la police Poppins et le theme rouge/blanc.
- [x] Creer les dossiers Flutter `models/`, `services/`, `screens/`.
- [x] Creer le backend Python Flask de base.
- [x] Ajouter des donnees JSON de depart.
- [x] Ajouter un README de lancement.

## 2. Backend Python complet

- [x] Completer `ventes.json` avec au moins 10 produits et 3 categories.
- [x] Verifier que `POST /api/login` ne renvoie jamais le mot de passe.
- [x] Tester `GET /api/produits`.
- [x] Tester `GET /api/produits/<id>`.
- [x] Documenter les endpoints dans le README.

## 3. Connexion Flutter

- [x] Transformer l'ecran login en formulaire valide.
- [x] Appeler `POST /api/login` depuis `ApiService`.
- [x] Afficher le chargement pendant l'appel reseau.
- [x] Afficher les erreurs d'identifiants ou reseau.
- [x] Sauvegarder l'utilisateur avec `SessionService`.

## 4. Session et navigation

- [ ] Verifier la session au demarrage de l'application.
- [ ] Rediriger automatiquement vers la liste si l'utilisateur est connecte.
- [ ] Nettoyer la session a la deconnexion.
- [ ] Revenir proprement vers l'ecran login.

## 5. Liste des produits

- [ ] Charger les produits avec `GET /api/produits`.
- [ ] Afficher image, titre, categorie et prix.
- [ ] Ajouter les etats chargement, erreur et liste vide.
- [ ] Afficher le prenom de l'utilisateur connecte.
- [ ] Naviguer vers le detail au tap.

## 6. Detail produit

- [ ] Passer le produit selectionne a l'ecran detail.
- [ ] Afficher image, titre, description, categorie et prix.
- [ ] Soigner la mise en page Material 3.

## 7. Finition et verification

- [ ] Lancer les tests Flutter.
- [ ] Tester l'app avec le serveur local.
- [ ] Mettre a jour le README avec les identifiants de test.
- [ ] Ajouter un court rapport dans `docs/`.
- [ ] Preparer 3 a 5 captures d'ecran.

## 8. Bonus possibles

- [ ] Recherche par titre.
- [ ] Filtre par categorie.
- [ ] Favoris persistants.
- [ ] Route d'inscription.
