# 📦 Charger les bibliothèques
library(raster)
library(sf)
library(exactextractr)
library(dplyr)
library(tidyr)
library(readr)
library(purrr)
library(stringi)  # 🆕 Pour nettoyer les noms de régions

# 📁 Dossier contenant les rasters organisés
raster_dir <- "C:/Users/pc/OneDrive/Desktop/Projet_Bookdown/Bookdown/Atlas_Spectral_Sahel/data"

# 📁 Dossier contenant les shapefiles régionaux
shapes_dir <- "C:/Users/pc/OneDrive/Desktop/Projet_Bookdown/Bookdown/Atlas_Spectral_Sahel/data/shapes"

# 📜 Lister les indicateurs disponibles (sous-dossiers)
indicateurs <- list.dirs(raster_dir, recursive = FALSE, full.names = FALSE)

# 📊 Initialiser une table vide
resultats <- list()

# 🔁 Boucle sur chaque indicateur
for (indicateur in indicateurs) {
  # Lister les fichiers .tif pour cet indicateur
  files <- dir(file.path(raster_dir, indicateur), pattern = "\\.tif$", full.names = TRUE)
  
  for (f in files) {
    nom_fichier <- basename(f)
    
    # Extraire le pays depuis le nom du fichier
    parts <- unlist(strsplit(nom_fichier, "_"))
    pays <- gsub("\\.tif$", "", parts[2])  # Récupérer le pays
    
    # Charger le raster
    r <- raster(f)
    
    # Charger le shapefile des régions du pays
    shp_file <- file.path(shapes_dir, paste0("regions_", pays, ".shp"))
    if (!file.exists(shp_file)) {
      message("❌ Pas de shapefile pour", pays, "→ Ignoré")
      next
    }
    
    regions <- st_read(shp_file, quiet = TRUE)
    
    # Vérifier et harmoniser la projection
    if (st_crs(regions) != crs(r)) {
      regions <- st_transform(regions, crs(r))
    }
    
    # Vérifier et corriger les géométries invalides
    if (any(!st_is_valid(regions))) {
      regions <- st_make_valid(regions)
    }
    
    # Extraire la moyenne par région
    regions$valeur <- exact_extract(r, regions, 'mean')
    
    # 📌 **ICI, MODIFIE LE NOM DE LA COLONNE DES RÉGIONS MANUELLEMENT**
    col_region <- "ADM1_FR"  # Remplace par le vrai nom dans ton shapefile
    
    # 🔄 Nettoyage des noms de régions
    regions[[col_region]] <- stri_trans_general(regions[[col_region]], "Latin-ASCII")  # Supprime accents
    regions[[col_region]] <- gsub("[^a-zA-Z0-9 ]", "", regions[[col_region]])  # Supprime caractères spéciaux
    regions[[col_region]] <- trimws(regions[[col_region]])  # Supprime les espaces inutiles
    
    # Stocker les résultats sous format long (évite les .x et .y)
    df <- st_drop_geometry(regions) %>%
      select(region_name = all_of(col_region), valeur) %>%
      mutate(pays = pays, indicateur = indicateur)
    
    # Ajouter les résultats à la liste
    resultats[[paste0(indicateur, "_", pays)]] <- df
  }
}

# 🏗️ Fusionner toutes les tables en format long
resultats_long <- bind_rows(resultats)

# 🔄 Transformer en format large (chaque indicateur = 1 colonne)
resultats_final <- resultats_long %>%
  pivot_wider(names_from = indicateur, values_from = valeur)

# 💾 Sauvegarde en CSV avec UTF-8 (évite les problèmes d'encodage)
write_csv(resultats_final, "data/indicateurs_moyens_par_region.csv", na = "")

# ✅ Affichage des premières lignes
head(resultats_final)
