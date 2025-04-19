library(shiny)
library(bslib)
library(leaflet)
library(gt)

ui <- fluidPage(
  
  # 🎨 Thème Flatly modernisé
  theme = bs_theme(
    bootswatch = "flatly",
    primary = "#0077B6",
    base_font = font_google("Open Sans"),
    heading_font = font_google("Montserrat"),
    font_scale = 1.05
  ),
  
  # ✅ Feuille de style personnalisée (voir section CSS en bas)
  tags$head(includeCSS("www/style.css")),
  
  # 🧭 En-tête de l'application
  titlePanel(
    title = div(
      icon("globe-africa"),
      "Comparateur d'indicateurs environnementaux"
    )
  ),
  
  # 🧩 Bloc supérieur avec filtres
  sidebarLayout(
    sidebarPanel(
      h4("🎛️ Paramètres"),
      tags$hr(),
      
      selectInput("pays", "Choisir les pays :", 
                  choices = c("Sénégal", "Mali", "Niger", "Burkina Faso"),
                  multiple = TRUE, selected = "Sénégal"),
      
      selectInput("famille", "Type d'indicateurs :", 
                  choices = c("Végétation", "Stress écologique", "Eau / Humidité")),
      
      uiOutput("indicateur_ui"),
      
      tags$hr(),
      tags$p("Sélectionnez les paramètres ci-dessus, puis explorez les résultats via les onglets en bas.")
    ),
    
    mainPanel(
      div(
        style = "padding: 20px; background-color: #f9f9f9; border-radius: 8px; box-shadow: 0 0 6px rgba(0,0,0,0.1);",
        h4("📊 Résumé interactif"),
        p("Utilisez les onglets ci-dessous pour visualiser la carte, le tableau ou le graphique correspondant.")
      ),
      br(),
      textOutput("commentaire"),
      br(), br()
    )
  ),  # ✅ FERMETURE du sidebarLayout ici
  
  # 🧭 Onglets en bas
  tabsetPanel(
    tabPanel("🗺️ Carte", leafletOutput("carte", height = "600px")),
    tabPanel("📋 Tableau de données", uiOutput("tableau_ui")),
    tabPanel("📈 Graphiques comparatifs", plotOutput("comparatif_plot", height = "550px"))
  )
)
