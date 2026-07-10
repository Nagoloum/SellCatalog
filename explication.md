# Explication du projet SellCatalog

Ce fichier explique le projet comme si tu debutais en developpement. L'objectif
est de comprendre comment les morceaux se parlent entre eux.

## 1. Idee generale

Le projet a deux parties :

- `server/` : le backend Python. Il recoit des requetes HTTP et renvoie des
  donnees JSON.
- `flutter_app/` : l'application Flutter. Elle affiche les ecrans et appelle le
  backend.

Flutter ne lit pas directement les fichiers JSON du serveur. Il passe par des
routes API comme `/api/login` ou `/api/produits`.

## 2. C'est quoi un composant Flutter ?

Dans Flutter, presque tout est un widget. Un widget est un morceau d'interface.

Exemple simple :

```dart
Text('Connexion')
```

Ici, `Text` est un widget qui affiche du texte.

Un ecran complet est aussi un widget. Par exemple :

```text
lib/screens/login_screen.dart
```

Ce fichier contient l'ecran de connexion. Il utilise plusieurs widgets :

- `Scaffold` : structure de base d'un ecran.
- `Stack` : superpose plusieurs elements.
- `Image.asset` : affiche une image locale.
- `Form` : regroupe les champs d'un formulaire.
- `TextFormField` : champ de saisie avec validation.
- `FilledButton` : bouton principal.

## 3. Comment un composant est personnalise

Un widget se personnalise avec ses proprietes.

Exemple :

```dart
FilledButton(
  onPressed: _submit,
  child: const Text('Se connecter'),
)
```

Ici :

- `onPressed` dit quoi faire quand on clique.
- `child` est le contenu du bouton.

Pour personnaliser les couleurs globales, on utilise le theme dans :

```text
flutter_app/lib/main.dart
```

Le theme configure :

- Material 3 avec `useMaterial3: true`.
- La police Poppins avec `fontFamily: 'Poppins'`.
- Le rouge principal avec `ColorScheme`.
- Les boutons, champs et AppBar.

Ainsi, les ecrans gardent un style coherent sans devoir tout recopier partout.

## 4. C'est quoi un ecran Stateful ?

Il existe deux grands types de widgets :

- `StatelessWidget` : ne change pas tout seul.
- `StatefulWidget` : peut changer pendant que l'app tourne.

Exemple : l'ecran de connexion est un `StatefulWidget`, car il doit gerer :

- le texte tape par l'utilisateur,
- le chargement pendant l'appel API,
- le message d'erreur,
- la navigation apres connexion.

Quand une valeur change, on appelle :

```dart
setState(() {
  _isLoading = true;
});
```

Flutter reconstruit alors l'ecran avec les nouvelles valeurs.

## 5. Comment les API sont creees cote backend

Le fichier principal du backend est :

```text
server/server.py
```

Une route Flask ressemble a ca :

```python
@app.get("/api/produits")
def products():
    return jsonify(load_json("ventes.json"))
```

Explication :

- `@app.get("/api/produits")` declare une route HTTP GET.
- `def products()` est la fonction executee quand la route est appelee.
- `load_json("ventes.json")` lit les produits.
- `jsonify(...)` renvoie une reponse JSON.

Pour la connexion, on utilise une route POST :

```python
@app.post("/api/login")
def login():
```

POST veut dire que le client envoie des donnees, par exemple email et mot de
passe.

## 6. Comment Flutter appelle les API

Les appels API Flutter sont regroupes ici :

```text
flutter_app/lib/services/api_service.dart
```

Exemple pour charger les produits :

```dart
final response = await _client.get(Uri.parse('$baseUrl/api/produits'));
```

Explication :

- `baseUrl` contient l'adresse du serveur.
- `/api/produits` est la route appelee.
- `await` veut dire : attendre la reponse avant de continuer.
- `response.body` contient le JSON renvoye par Flask.

Ensuite, le JSON est transforme en objets Dart :

```dart
Product.fromJson(item)
```

Ca permet de manipuler un vrai objet `Product` au lieu d'un simple texte JSON.

## 7. C'est quoi un model ?

Un model represente une donnee.

Exemple :

```text
flutter_app/lib/models/product.dart
```

Ce fichier dit qu'un produit a :

- un `id`,
- une `image`,
- un `titre`,
- une `description`,
- une `categorie`,
- un `prix`.

Le model contient aussi :

```dart
factory Product.fromJson(Map<String, dynamic> json)
```

Cette fonction convertit le JSON de l'API en objet Dart.

## 8. Comment fonctionne la session

La session est geree dans :

```text
flutter_app/lib/services/session_service.dart
```

Quand un utilisateur se connecte, on sauvegarde ses informations localement :

```dart
await _sessionService.saveUser(user);
```

Au lancement de l'application, l'ecran `SessionGateScreen` verifie s'il existe
deja une session.

Si oui, il envoie vers la liste des produits. Sinon, il envoie vers la connexion.

## 9. Comment fonctionnent les favoris

Les favoris sont geres dans :

```text
flutter_app/lib/services/favorites_service.dart
```

Le service garde une liste d'ids de produits favoris avec
`shared_preferences`.

Quand on clique sur le coeur :

```dart
await _favoritesService.toggleFavorite(productId);
```

Si le produit etait favori, il est retire. Sinon, il est ajoute.

La liste et le detail lisent ensuite cette information pour afficher un coeur
plein ou vide.

## 10. Comment fonctionnent recherche et filtres

Dans `products_screen.dart`, on charge d'abord tous les produits depuis l'API.

Ensuite, on filtre localement avec trois conditions :

- le texte recherche est dans le titre ou la description,
- la categorie correspond au filtre choisi,
- le produit est favori si le mode favoris uniquement est active.

Cela evite de rappeler le serveur a chaque lettre tapee.

## 11. Navigation entre ecrans

Les routes sont declarees dans :

```text
flutter_app/lib/main.dart
```

Exemple :

```dart
ProductsScreen.routeName: (_) => const ProductsScreen(),
```

Pour aller vers un autre ecran :

```dart
Navigator.of(context).pushNamed(ProductsScreen.routeName);
```

Pour remplacer l'ecran actuel :

```dart
Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
```

Pour envoyer un produit vers l'ecran detail :

```dart
Navigator.of(context).pushNamed(
  ProductDetailScreen.routeName,
  arguments: product,
);
```

L'ecran detail recupere ensuite `arguments`.

## 12. Ce qu'un dev doit retenir

- Separons les responsabilites : ecrans, services, models.
- Un ecran appelle un service, pas directement une API partout.
- Un service API transforme les reponses JSON en objets Dart.
- `setState` sert a mettre a jour l'interface.
- `SharedPreferences` sert a garder de petites donnees locales.
- Les erreurs reseau doivent etre affichees a l'utilisateur.
- Les formulaires doivent valider les champs avant d'appeler l'API.
- Un theme global evite de recopier les styles partout.
