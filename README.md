# 📚 Projet Bookdown — Tutoriel & Application (cas pratique)

Bienvenue dans ce dépôt dédié à **Bookdown**, un outil puissant de l’écosystème **R** permettant de créer des **livres interactifs**, des **rapports scientifiques** et des **documents multi-formats** à partir de R Markdown.

Ce dépôt est **principalement centré sur Bookdown** et illustre une démarche complète allant :
**de l’apprentissage des bases → à l’application sur un cas réel**.

---

## 🎯 Objectif du dépôt

Le projet est structuré autour de **deux volets complémentaires** :

- 📘 **Un tutoriel Bookdown** pour apprendre pas à pas la création et la publication de livres interactifs
- 🧭 **Une application pratique sous forme de livre Bookdown**, illustrant la structuration d’un document académique réel sur un thème concret

Un module **Shiny** est inclus uniquement comme **support technique** afin d’enrichir l’interactivité du livre d’application.

---

## 📘 1. Tutoriel Bookdown

📂 Dossier : `Tutorial Bookdown/`

Ce dossier contient un **livre tutoriel interactif** destiné aux étudiants, enseignants et professionnels souhaitant :

- installer et configurer Bookdown
- créer un projet complet avec RStudio ou en ligne de commande
- structurer un livre avec `_bookdown.yml` et `_output.yml`
- personnaliser le rendu (YAML, CSS, LaTeX)
- intégrer des images, vidéos, audio et contenus interactifs et meme une application shiny
- publier un livre en ligne (GitHub Pages, Netlify, bookdown.org)
- concevoir un **template Bookdown réutilisable**

🔗 **Lire le tutoriel en ligne** :  [Cliquez-ici](https://bookdown.org/ahmadouniass2/Bookdown_tutorial) 

---

## 🧭 2. Application pratique — Livre Bookdown

📂 Dossier : `Atlas Spectral Sahel Bookdown/`

Ce volet correspond à une **application concrète des concepts présentés dans le tutoriel**, sous la forme d’un **livre thématique structuré avec Bookdown**.

Il illustre notamment :

- la structuration d’un document académique complet
- l’analyse de données réelles avec R
- l’intégration de graphiques, cartes et tableaux
- la production de rendus HTML et PDF de qualité
- l’organisation avancée des fichiers (YAML, CSS, préambule LaTeX)
- l’enrichissement du contenu avec des éléments interactifs

🔗 **Lire le livre d’application en ligne** :  [Cliquez-ici](https://bookdown.org/ahmadouniass2/Atlas-Spectral-Sahel/)
---

## 🧩 Module Shiny (support d’interactivité)

📂 Dossier : `Atlas Spectral Sahel Application/`

Ce dossier contient le **code Shiny utilisé uniquement pour démontrer et faciliter l’intégration de composants interactifs** (cartes, filtres, visualisations) au sein du livre Bookdown d’application.

> ⚠️ Ce module ne constitue pas un projet autonome :  
> il sert exclusivement de **support technique** au livre Bookdown.

---

## 🚀 Technologies utilisées

- **R**
- **RStudio**
- **Bookdown / R Markdown**
- **Shiny** (intégration interactive)
- **Pandoc**
- **TinyTeX**
- GitHub Pages, Netlify, bookdown.org (déploiement)

---

## 📂 Organisation du dépôt

```text
/
├── Tutorial Bookdown/                     # 📘 Livre tutoriel : prise en main de Bookdown
│   ├── index.Rmd                          # Page d’accueil du tutoriel
│   ├── _bookdown.yml                     # Ordre des chapitres
│   ├── _output.yml                       # Formats de sortie (HTML / PDF)
│   ├── Bookdown/                         # Chapitres du tutoriel (.Rmd)
│   │   ├── 01-introduction.Rmd
│   │   ├── 02-installation.Rmd
│   │   ├── 03-structure-projet.Rmd
│   │   ├── 04-rmarkdown.Rmd
│   │   ├── 05-personnalisation.Rmd
│   │   ├── 06-medias-interactifs.Rmd
│   │   ├── 07-deploiement.Rmd
│   │   └── 08-template-reutilisable.Rmd
│   ├── images/                           # Images utilisées dans le tutoriel
│   ├── media/                            # Audio / vidéo intégrés
│   └── README.md                         # Présentation du tutoriel
│
├── Atlas Spectral Sahel Bookdown/         # 🧭 Livre d’application (atlas environnemental)
│   ├── index.Rmd                          # Introduction générale de l’atlas
│   ├── _bookdown.yml                     # Structure des chapitres
│   ├── _output.yml                       # Rendus HTML / PDF
│   ├── data/                             # Données utilisées (ou scripts de chargement)
│   │   ├── ndvi/
│   │   ├── evi/
│   │   ├── lswi/
│   │   └── shapes/
│   ├── images/                           # Figures et cartes statiques
│   ├── media/                            # Médias intégrés (audio / vidéo)
│   ├── chapters/                         # Chapitres du livre (.Rmd)
│   │   ├── 01-introduction.Rmd
│   │   ├── 02-senegal.Rmd
│   │   ├── 03-burkina-faso.Rmd
│   │   ├── 04-mali.Rmd
│   │   ├── 05-niger.Rmd
│   │   └── 06-comparaison-interpays.Rmd
│   ├── style.css                         # Personnalisation du rendu HTML
│   ├── preamble.tex                      # Préambule LaTeX (PDF)
│   └── README.md                         # Présentation du livre d’application
│
├── Atlas Spectral Sahel Application/      # 🧩 Support Shiny pour Bookdown
│   ├── app.R                              # Application Shiny (cartes, filtres)
│   ├── modules/                          # Modules Shiny réutilisables
│   │   ├── map_module.R
│   │   └── indicator_module.R
│   ├── data/                             # Données nécessaires à l’interactivité
│   ├── www/                              # Ressources web (CSS, JS)
│   └── README.md                         # Rôle du module Shiny
│
├── .gitignore                            # Fichiers générés ignorés
└── README.md                             # Présentation générale du dépôt
```
## ✍️ Auteurs

* **Ahmadou Niass** — ENSAE Pierre Ndiaye, Élève Ingénieur Statisticien
* **Samba Sow** — ENSAE Pierre Ndiaye, Élève Ingénieur Statisticien Économiste

📘 **Sous la supervision de** :
**M. Aboubacar HEMA**, Research Analyst

---

## 📬 Contact & contributions

Pour toute remarque, suggestion ou collaboration,
n’hésitez pas à **ouvrir une issue** ou proposer une **pull request**.