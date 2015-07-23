DEV NOTES
=========

(notes about development , in french only ,sorry)

### Crud generation

#### Générer :
 1. controlleur qui étend AbstractCRUD
 2. un service qui étant entity service
 3. 4 fichiers templates

#### Variables :
- dossier des controlleurs
- namespace des controlleurs
- dossier des services
- namespace des services
- dossier des templates
mv to
les variables peuvent être surchargées avec le cli

### Autorisation et authentification, gestion des utilisateurs :

@note @silex gérer les utilisateurs avec symfony/security et doctrine

- l'entité User doit implémenter l'interface ***serializable***
pour être utilisée avec symfony/security sinon , php renvoie une érreur




