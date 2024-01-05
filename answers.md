#  Réponses aux questions :

 # 1 - Environnement
 
 ## Exercice 1
 
 ### Les targets

Un **target** est un objet destinataire d'une action déclenchée par l'utilisateur. Il est souvent associé à un "action", une fonction ou une méthode spécifique à appeler lorsque l'événement se produit.

Exemple : un bouton appuyé ou un changement de valeur dans un contrôle.

- Cible de compilation
- Point d'entrée
 
 ### Les fichiers
 Les différents fichiers présent lors du lancement d'une application xCode : 
 
- **AppDelegate.swift :** c'est le fichier qui permet le relais entre le système d'exploitation et notre app. Il contient une classe "AppDelegete" qui hérite de UIResponder et UIApplicationDelegate. Simplement, il s’agit d’un groupement de fonctions conforme à un certain modèle permettant l’interaction entre le système et l’app.
- **SceneDelegate.swift :** C'est le fichier qui va gérer ce qui va être montrer sur notre application. (L'UI)
- **ViewController :** C'est le fichier dans lequel sera appelé le code
- **Les storyboards & LaunchScreen :** sont les fichiers d'interface 
 
 ### Les assets
Les **asssets** sont organisés dans un fichier dédié nommé "Assets", ce fichier va contenir différentes choses que l'on pourra ajouter à notre appliation comme : 
- Les couleurs
- Les images
- L'icône de notre application
etc...

 ### Ouvrir le storyboard
 Un **storyboard** est une **inferface**, ce qui pourrait s'apparenter à du HTML pour du Javascript.
 
 Les différents storyboards disponibles lors de la création d'un projet :
- Main
- LaunchScreen

 ### Ouvrir un simulateur
 Pour ouvrir un simulateur il suffit de se rendre dans la barre tout en haut de xcode et de sélectionné l'icône de téléphone et choisir l'appareil que l'on souhaite lancer.
 
 ### Lancer une application sur le simulateur
 Pour lancer notre application sur le simulateur il suffit simplement de cliquer sur l'icône "Play" dans XCode. Cela va "Build" l'application et la lancer sur le simulateur.
 
## Exercice 2

### A quoi sert le raccourci Cmd + R ?
**Cmd + R** permet de build et run l'application dans le simulateur ou sur l'appareil.
### A quoi sert le raccourci Cmd + Shift + O ?
**Cmd + Shift + O** permet d'ouvrir un "moteur de recherche" dans les fichiers de notre application
### Trouver le raccourci pour indenter le code automatiquement
Pour réindenter automatiquement un code sélectionné : **Ctrl + I**
Pour réindenter tout le fichier **Cmd + A**, puis **Ctrl + I**
### Et celui pour commenter la selection.
Pour commenter une séléction **Cmd + :** 

# 3 - Delegation

## 🔧 Exercice 1
**Expliquer l’intérêt d’une variable statique en programmation.**


L'avantage d'une variable statique est qu'elle va rester tout au long du run de l'application, ici ça nous est utile afin de garder les `documentFile` de test.

## 🔧 Exercice 2

**Expliquer pourquoi dequeueReusableCell est important pour les performances de l’application.**

dequeueReusableCell est important pour les performances de l'application car il permet de réutiliser la cellule plutôt que d'en recréer une nouvelle à chaque fois.

# 4 - Navigation

## 🔧 Exercice 1

**Que venont nous de faire en réalité ?** 
Nous venons de créer le module de naviation qui va permettre de faire le flow de navigation

**Quel est le rôle du NavigationController ?**
Le navigationController va connaître toutes les pages et permettre de naviguer. 

**Est-ce que la NavigationBar est la même chose que le NavigationController ?**
Non les deux sont bien différents car le controller va connaître les pages et savoir lesquelles communiquent enntre elles et la NavigationBar est simplement la matérialisation visuelle du titre et des propriétés de l'élément de navigation dan lequel nous sommes.

# 6 - Ecran Détail

## 🔧 Exercice 1
**Expliquer ce qu’est un Segue et à quoi il sert**
Un Segue en UIKit est une transition qui va permettre de naviguer entre deux vues de l'interface

## 🔧 Exercice 2
**Qu’est-ce qu’une constraint ? A quoi sert-elle ? Quel est le lien avec AutoLayout ?**

Une constraint ou contrainte permet de positionner les éléments dans l'interface. L'AutoLayout va positionner automatiquement les éléments dans l'interface mais si un élément possède par exemple une contrainte avec le côté gauche de l'écran l'AutoLayout sera obligé de respecter cette contrainte.

# 9 - QLPreview

**Pourquoi serait-il plus pertinent de changer l’accessory de nos cellules pour un disclosureIndicator ?**
Le disclosureIndicator permettra de montrer à l'utilisateur qu'il peut consulter + de détails sur l'élément en question.

# 10
**A quoi sert la fonction defer ?**
La fonction defer permet de 'retardé' l'éxecution du code dans un block, par exemple :

func exemple() {
 defer {
     // Code de defer
 }
 
 // Code de la fonction
} -> Defer sera normalement executé juste avant de sortir d'ici
