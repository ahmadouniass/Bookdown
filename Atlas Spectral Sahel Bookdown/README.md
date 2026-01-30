# 🌍 Atlas interactif des dynamiques environnementales en Afrique de l’Ouest

Ce projet est un **livre interactif** développé avec **R Bookdown**. Il vise à cartographier, visualiser et analyser les **dynamiques environnementales** dans quatre pays sahéliens à partir d'**indices spectraux dérivés d'images satellites**.

📘 L'atlas propose une lecture **multi-échelle** des dynamiques végétales, hydriques et de stress écologique, avec un accent particulier sur les contrastes régionaux et les vulnérabilités environnementales.

🔗 **Accéder au livre en ligne** : [Cliquez-ici](https://bookdown-atlas-spectral.netlify.app/)

---

## 📦 Structure du projet

Le Bookdown est structuré en plusieurs chapitres :

- **Introduction et contexte** : présentation du projet, objectifs et cadre méthodologique.
- **Chapitres pays** :
  - Sénégal
  - Burkina Faso
  - Mali
  - Niger
- **Comparaison inter-pays** : analyse croisée des dynamiques environnementales.

---

## ✨ Fonctionnalités interactives

Ce livre numérique intègre de nombreuses fonctionnalités interactives :

| Fonctionnalité                            | Description                                                                 |
|-------------------------------------------|-----------------------------------------------------------------------------|
| 🌐 **Cartes interactives `leaflet`**       | Visualisation dynamique des indicateurs par région                          |
| 🗺️ **Cartes statiques `tmap`**            | Cartes thématiques prêtes à l'impression                                    |
| 📊 **Tableaux dynamiques `gt`**           | Moyennes régionales colorées pour chaque indicateur                         |
| 📈 **Analyse textuelle détaillée**         | Interprétation écologique, comparaison nord-sud, mise en contexte locale    |
| 🔎 **Navigation fluide**                   | Table des matières latérale, titre toujours visible, design harmonisé       |
| 🎧 **Introduction audio intégrée**         | Présentation vocale du projet                                               |
| 📹 **Vidéo explicative intégrée**          | Vidéo embarquée dans le chapitre d’introduction                             |
| 📥 **Téléchargement PDF disponible**       | Export complet du livre au format PDF                                       |

---

## 🛰️ Données utilisées

Les données proviennent d'images satellites multispectrales (Sentinel-2, Landsat), retraitées sous forme de **rasters haute résolution** puis agrégées par région administrative.

Les **indices spectraux** utilisés incluent (entre autres) :

- **NDVI** : couverture végétale verte
- **EVI** : productivité végétale
- **LSWI / ANDWI** : humidité du sol et des surfaces
- **ARI / BAI / FAI** : stress végétal et dégradation
- **AWEI** : zones humides
- **BNDVI** : alternative NDVI pour zones à faible végétation

---

## 🔧 Technologies & Packages

Ce projet est développé sous **R** avec les packages suivants :

- [`bookdown`](https://bookdown.org/)
- [`leaflet`](https://rstudio.github.io/leaflet/)
- [`tmap`](https://cran.r-project.org/package=tmap)
- [`gt`](https://gt.rstudio.com/)
- [`raster`, `terra`, `sf`, `exactextractr`] pour la gestion spatiale

---

## 👩🏽‍🏫 Réalisé par

- **Ahmadou Niass**  
- **Samba Sow**  
Élèves à l’ENSAE Pierre Ndiaye de Dakar

**Encadrant** : [M. Aboubacar HEMA](https://github.com/Abson-dev) – Research Analyst

---

## 📚 Licence

Ce projet est librement consultable à des fins pédagogiques. Toute reproduction à grande échelle doit être autorisée par les auteurs.
