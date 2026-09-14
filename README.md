# Projet_R_Odontologie
Projet d'analyse statistique avec R et modèles mixtes

## 📊 Analyse Comportementale en Odontologie : L'impact de la Réforme des Études de Santé

### 📝 Contexte du Projet

Ce dépôt rassemble les scripts d'analyse d'une base de données en économie comportementale portant sur les étudiants en odontologie en France (N = 812 observations).

Initié lors de mon stage de recherche à l'AMSE (Marseille), ce projet visait initialement à traiter les données sous Stata. Dans une démarche d'amélioration continue et d'approfondissement, j'ai récemment entrepris une réplication étendue sous R. Cette V2 intègre de nouvelles observations, des techniques de nettoyage de données plus robustes et des modélisations statistiques avancées (Modèles Mixtes).

> ⚠️ **Note confidentialité / RGPD :** pour des raisons strictes de confidentialité et de conformité au RGPD, la base de données brute (`data_odonto_all.csv` / `data_all_net.xlsx`) n'est pas hébergée sur ce dépôt. Seuls les scripts d'analyse sont partagés.

### 🛠️ Technologies & Packages Utilisés

**R (V2 - Analyse Avancée) :**
- Manipulation & Nettoyage : `tidyverse` (`dplyr`, `tidyr`), `janitor`
- Modélisation : `lme4` et `lmerTest` (Linear Mixed-Effects Models)
- Visualisation & Reporting : `ggplot2`, `gtsummary`, `flextable`, `officer`

**Stata (V1 - Analyse Initiale) :** traitement des données d'enquête, factorisation, construction de scores psychométriques, automatisation d'export Word (`putdocx`).

### 📂 Structure du Dépôt

- **`Data_analyse_R.Rmd`** : script R principal (Version 2). Contient le pipeline complet : recodage complexe (correction des anomalies géographiques), traitement des valeurs aberrantes, statistiques descriptives croisées et modélisation par modèles mixtes.
- **`do_Stage.do`** : script Stata (Version 1). Contient la logique initiale de construction des scores psychométriques (Échelle de Jefferson, scores ECOS/CARE) et les premières statistiques descriptives.

### 🔬 Méthodologie et Apports

**1. Ingénierie des Variables & Psychométrie**
- Construction d'indices complexes mesurant l'Empathie (JSE, cas cliniques), l'Orientation Sociale (SVO Angle) et la Prise de Risque (tâche BRET - Bomb Risk Elicitation Task).
- Mesure de l'altruisme via le différentiel de risque pris pour soi vs pour autrui.

**2. Data Cleaning & Robustesse (Nouveauté R)**
- Deux méthodes de filtrage pour la tâche BRET :
  - un nettoyage *comportemental* (exclusion des stratégies absurdes 0 ou 100) ;
  - un nettoyage *statistique* (exclusion des individus à plus de 2 écarts-types de la moyenne).

**3. Modélisation Économétrique (Modèles Mixtes)**
- Face à la structure hiérarchique des données (étudiants regroupés par villes/facultés), utilisation de modèles mixtes (`lmer`, `glmer`).
- **Effet fixe :** impact de la filière d'origine (LAS, PASS, PACES, Passerelle), du genre, de l'âge et du niveau d'études des parents.
- **Effet aléatoire :** l'université de rattachement (`1 | Faculte`), permettant d'isoler l'impact réel de la réforme (PASS/LAS) indépendamment des spécificités locales de chaque faculté.

### 🚀 Comment lire / exécuter ce projet ?

Consultez en priorité le fichier **`Data_analyse_R.Rmd`**, qui illustre l'approche la plus aboutie (du nettoyage robuste à l'export industrialisé des résultats économétriques via `gtsummary`).

Pour exécuter les scripts, la base de données étant confidentielle et non incluse :
1. Placez le fichier de données (`data_odonto_all.csv` pour R, `data_all_net.xlsx` pour Stata) à la racine du projet.
2. **R :** ouvrez `Data_analyse_R.Rmd` dans RStudio et installez les packages listés ci-dessus (`install.packages(c("tidyverse", "janitor", "lme4", "lmerTest", "gtsummary", "flextable", "officer"))`), puis exécutez (`Knit` ou chunk par chunk).
3. **Stata :** exécutez `do_Stage.do` (le script attend `data_all_net.xlsx` à la racine).
