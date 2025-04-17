library(rmarkdown)

# 📜 Liste des pays et catégories d’indices
pays_list <- c("senegal", "mali", "niger", "burkina")
categories <- c("vegetation", "urbanisation", "eau", "sol")

# 🔁 Générer un rapport dynamique pour chaque pays et chaque catégorie
for (p in pays_list) {
  for (cat in categories) {
    render("rapport_template.Rmd", 
           output_file = paste0("Rapport_", p, "_", cat, ".html"),
           params = list(pays = p, categorie = cat))
  }
}
