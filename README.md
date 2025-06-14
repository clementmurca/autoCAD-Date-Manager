# AutoCAD Date Dynamique

Un ensemble de scripts PowerShell pour gérer automatiquement les dates dans AutoCAD en utilisant des variables d'environnement.

## 📋 Description

Ce projet permet de définir automatiquement une variable d'environnement `AUTOCAD_CURRENT_DATE` avec la date du jour au format `année-jour-` (ex: 2025-156-). Cette variable peut ensuite être utilisée dans AutoCAD pour automatiser la gestion des dates dans vos dessins.

## 📁 Fichiers inclus

- **`autocad_date_manager.ps1`** : Script principal qui génère et définit la variable d'environnement
- **`install_autocad_scheduler.ps1`** : Script d'installation qui configure les tâches automatiques
- **`delete_environnement_variable.ps1`** : Script pour supprimer la variable d'environnement
- **`date_config.json`** : Fichier de configuration (optionnel)

## 🚀 Installation rapide

### Étape 1 : Télécharger les fichiers
Téléchargez tous les fichiers PowerShell dans un même dossier sur votre ordinateur.

### Étape 2 : Installation automatique
1. **Clic droit** sur l'icône PowerShell dans le menu Démarrer
2. Sélectionnez **"Exécuter en tant qu'administrateur"**
3. Naviguez vers le dossier contenant les scripts
4. Exécutez la commande :
**`.\install_autocad_scheduler.ps1`**


C'est tout ! Le script va automatiquement :
- Configurer deux tâches planifiées
- Exécuter le script immédiatement
- Définir la variable d'environnement

## ⚙️ Fonctionnement

### Tâches automatiques créées
1. **"AutoCAD Date - Session Active"** : Exécute le script à chaque connexion Windows
2. **"AutoCAD Date - Daily"** : Exécute le script tous les matins à 7h00

### Variable d'environnement
- **Nom** : `AUTOCAD_CURRENT_DATE`
- **Format** : `2025-156-` (année-numéro du jour dans l'année)
- **Mise à jour** : Automatique chaque jour

## 🔧 Utilisation

### Utilisation manuelle
Pour exécuter le script manuellement :
**`.\autocad_date_manager.ps1`**

Pour lancer AutoCAD avec la variable mise à jour :
**`.\autocad_date_manager.ps1 -launch`**

### Dans AutoCAD
Une fois la variable définie, vous pouvez l'utiliser dans AutoCAD en tapant :
%AUTOCAD_CURRENT_DATE%

## 📝 Configuration

Créez un fichier `date_config.json` pour personnaliser le format :
{
"date_format": "yyyy-DDD",
"auto_update": true
}

## 🗑️ Désinstallation

Pour supprimer la variable d'environnement :
**`.\delete_environnement_variable.ps1`**

Pour supprimer les tâches planifiées :
1. Ouvrez le **Planificateur de tâches** (tapez `taskschd.msc`)
2. Supprimez les tâches "AutoCAD Date - Session Active" et "AutoCAD Date - Daily"

## ❓ Résolution de problèmes

### Le script ne s'exécute pas
- Vérifiez que PowerShell est exécuté **en tant qu'administrateur**
- Vérifiez la politique d'exécution avec : `Get-ExecutionPolicy`
- Si nécessaire, autorisez l'exécution : `Set-ExecutionPolicy RemoteSigned`

### AutoCAD ne trouve pas la variable
- Redémarrez AutoCAD après l'installation
- Vérifiez que la variable existe avec : `echo $env:AUTOCAD_CURRENT_DATE`

### Les tâches ne s'exécutent pas
- Ouvrez le Planificateur de tâches (`taskschd.msc`)
- Vérifiez l'état des tâches "AutoCAD Date"
- Consultez l'historique des tâches pour les erreurs

## 🔍 Vérification

Pour vérifier que tout fonctionne :
1. Ouvrez PowerShell
2. Tapez : `echo $env:AUTOCAD_CURRENT_DATE`
3. Vous devriez voir quelque chose comme : `2025-156-`

---