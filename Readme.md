# Gestion des projets NETYJI

## Prérequis

```bash
sudo apt install make
```

## Installation

1. Clonez le dépôt dans le répertoire :
```bash
git clone git@github.com:netyji-solution/installer.git .
```

2. Ajoutez votre jeton d'accès personnel GitHub. Pour en générer un, rendez-vous sur la page suivante : https://github.com/settings/tokens/new?scopes=repo&description=Composer+on+GitHub

3. Créez un fichier .env à la racine et ajoutez votre jeton d'accès personnel GitHub en tant que variable d'environnement GITHUB_TOKEN.


## Installation des projets

```bash
1. **netyji_solution**
   - Lance l'installation complète du projet netyji_solution :
     ```bash
     make install_netyji_solution
     ```

2. **factur_x_pdf**
   - Lance l'installation complète du projet factur_x_pdf :
     ```bash
     make install_factur_x_pdf
     ```

3. **factur_x_xml**
   - Lance l'installation complète du projet factur_x_xml :
     ```bash
     make install_factur_x_xml
     ```

4. **compta_export**
    - Lance l'installation complète du projet compta_export :
      ```bash
      make install_compta_export
      ```