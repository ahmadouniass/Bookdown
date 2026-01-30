library(shiny)
library(dplyr)
library(leaflet)
library(sf)
library(raster)
library(exactextractr)
library(scales)
library(gt)
library(gtExtras)
library(stringi)

server <- function(input, output, session) {
  
  # Groupes d’indicateurs
  familles <- list(
    "Végétation" = c("ndvi", "evi", "arvi", "atsavi", "avi", "bndvi"),
    "Stress écologique" = c("bi", "bitm", "bixs", "embi", "bai", "dbsi"),
    "Eau / Humidité" = c("andwi", "lswi", "wi2", "aweinsh", "aweish")
  )
  
  # Sélection dynamique de l’indicateur selon la famille choisie
  output$indicateur_ui <- renderUI({
    selectInput("indicateur", "Choisir un indicateur :",
                choices = familles[[input$famille]],
                selected = familles[[input$famille]][1])
  })
  
  # Fonction de rendu Leaflet multi-pays
  output$carte <- renderLeaflet({
    req(input$pays, input$indicateur)
    
    indicator <- input$indicateur
    pays_liste <- input$pays
    
    leaflet_proxy <- leaflet() %>%
      addProviderTiles("CartoDB.Positron")
    
    extents <- list()
    valeurs_globales <- c()
    rast_list <- list()
    
    # Charger les rasters valides
    for (pays in pays_liste) {
      pays_id <- stringi::stri_trans_general(pays, "Latin-ASCII") |> tolower()
      raster_path <- paste0("data/", indicator, "/", indicator, "_", pays_id, ".tif")
      if (!file.exists(raster_path)) next
      
      rast <- raster::raster(raster_path)
      valeurs_globales <- c(valeurs_globales, values(rast))
      extents[[pays]] <- extent(rast)
      rast_list[[pays]] <- rast
    }
    
    # Aucun raster trouvé
    if (length(rast_list) == 0) {
      showNotification("❌ Aucun raster trouvé pour les pays sélectionnés.", type = "error")
      return(NULL)
    }
    
    # Palette commune
    pal <- colorNumeric("YlGnBu", valeurs_globales, na.color = "#f2f2f2")
    
    # Ajout des couches raster sur la carte
    for (pays in names(rast_list)) {
      leaflet_proxy <- leaflet_proxy %>%
        addRasterImage(rast_list[[pays]], colors = pal, opacity = 0.7, group = pays)
    }
    
    # Zoom automatique sur l’ensemble
    if (length(extents) > 0) {
      xmin <- min(sapply(extents, function(e) e@xmin))
      xmax <- max(sapply(extents, function(e) e@xmax))
      ymin <- min(sapply(extents, function(e) e@ymin))
      ymax <- max(sapply(extents, function(e) e@ymax))
      
      leaflet_proxy <- leaflet_proxy %>%
        fitBounds(xmin, ymin, xmax, ymax)
    }
    
    # Légende finale
    leaflet_proxy %>%
      addLegend(pal = pal, values = valeurs_globales, title = toupper(indicator))
  })
  output$tableau_ui <- renderUI({
    req(input$pays, input$indicateur)
    
    if (length(input$pays) == 1) {
      gt_output("gt_table")
    } else {
      DT::dataTableOutput("dt_table")
    }
  })
  output$gt_table <- render_gt({
    req(input$pays, input$indicateur)
    validate(need(length(input$pays) == 1, "Veuillez sélectionner un seul pays."))
    
    indicator <- input$indicateur
    pays_id <- stringi::stri_trans_general(input$pays[1], "Latin-ASCII") |> tolower()
    
    # Fichiers
    shapefile_path <- paste0("data/shapes/regions_", pays_id, ".shp")
    raster_path <- paste0("data/", indicator, "/", indicator, "_", pays_id, ".tif")
    
    if (!file.exists(shapefile_path) || !file.exists(raster_path)) {
      showNotification("Fichier manquant pour ce pays ou indicateur", type = "error")
      return(NULL)
    }
    
    rast <- raster::raster(raster_path)
    regions <- sf::st_read(shapefile_path, quiet = TRUE)
    
    moyennes <- exactextractr::exact_extract(rast, regions, 'mean')
    if (tolower(indicator) %in% c("ndvi")) moyennes <- moyennes / 10000
    
    df <- regions %>%
      sf::st_drop_geometry() %>%
      dplyr::select(Région = ADM1_FR) %>%
      dplyr::mutate(!!toupper(indicator) := round(moyennes, 3))
    
    df %>%
      gt() %>%
      tab_header(
        title = md(paste0("**Moyennes régionales – ", toupper(indicator), "**")),
        subtitle = paste0(tools::toTitleCase(input$pays[1]), " – Année 2024")
      ) %>%
      fmt_number(columns = 2, decimals = 3) %>%
      data_color(
        columns = 2,
        colors = scales::col_numeric("YlGnBu", domain = NULL)
      ) %>%
      gt_theme_538()
  })
  
  
  output$dt_table <- DT::renderDataTable({
    req(length(input$pays) > 1, input$indicateur)
    
    indicator <- input$indicateur
    all_data <- list()
    
    for (pays in input$pays) {
      pays_id <- stringi::stri_trans_general(pays, "Latin-ASCII") |> tolower()
      shapefile_path <- paste0("data/shapes/regions_", pays_id, ".shp")
      raster_path <- paste0("data/", indicator, "/", indicator, "_", pays_id, ".tif")
      
      if (!file.exists(shapefile_path) || !file.exists(raster_path)) next
      
      rast <- raster::raster(raster_path)
      regions <- sf::st_read(shapefile_path, quiet = TRUE)
      
      moyennes <- exactextractr::exact_extract(rast, regions, 'mean')
      if (tolower(indicator) %in% c("ndvi")) moyennes <- moyennes / 10000
      
      df <- regions %>%
        sf::st_drop_geometry() %>%
        dplyr::select(Région = ADM1_FR) %>%
        dplyr::mutate(
          Pays = tools::toTitleCase(pays),
          Valeur = round(moyennes, 3)
        ) %>%
        dplyr::select(Pays, Région, Valeur)
      
      all_data[[pays]] <- df
    }
    
    # Fusionner toutes les données
    tableau_final <- dplyr::bind_rows(all_data)
    
    if (nrow(tableau_final) == 0) {
      showNotification("Aucune donnée disponible pour les pays sélectionnés.", type = "error")
      return(NULL)
    }
    
    DT::datatable(
      tableau_final,
      options = list(
        pageLength = 10,
        autoWidth = TRUE,
        order = list(list(0, 'asc')),
        dom = 'tip'
      ),
      rownames = FALSE,
      class = "compact stripe hover"
    )
  })
  
  output$comparatif_plot <- renderPlot({
    req(input$pays, input$indicateur)
    
    indicator <- input$indicateur
    moyennes_par_pays <- list()
    
    for (pays in input$pays) {
      pays_id <- stringi::stri_trans_general(pays, "Latin-ASCII") |> tolower()
      shapefile_path <- paste0("data/shapes/regions_", pays_id, ".shp")
      raster_path <- paste0("data/", indicator, "/", indicator, "_", pays_id, ".tif")
      
      if (!file.exists(shapefile_path) || !file.exists(raster_path)) next
      
      rast <- raster::raster(raster_path)
      regions <- sf::st_read(shapefile_path, quiet = TRUE)
      
      valeurs <- exactextractr::exact_extract(rast, regions, 'mean')
      if (tolower(indicator) %in% c("ndvi")) valeurs <- valeurs / 10000
      
      moyenne <- mean(valeurs, na.rm = TRUE)
      
      moyennes_par_pays[[pays]] <- moyenne
    }
    
    df <- tibble::tibble(
      Pays = names(moyennes_par_pays),
      Moyenne = round(unlist(moyennes_par_pays), 3)
    )
    
    ggplot2::ggplot(df, ggplot2::aes(x = reorder(Pays, Moyenne), y = Moyenne, fill = Pays)) +
      ggplot2::geom_col(width = 0.6) +
      ggplot2::geom_text(
        ggplot2::aes(label = Moyenne),
        vjust = -0.5,
        size = 5
      ) +
      ggplot2::labs(
        title = paste("Valeurs moyennes nationales de", toupper(indicator)),
        x = NULL, y = "Valeur moyenne"
      ) +
      ggplot2::theme_minimal(base_size = 14) +
      ggplot2::theme(
        legend.position = "none",
        axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)
      )
  })
  
  output$commentaire <- renderText({
    req(input$pays, input$indicateur)
    indicator <- input$indicateur
    
    commentaires <- list()
    
    for (pays in input$pays) {
      pays_id <- stringi::stri_trans_general(pays, "Latin-ASCII") |> tolower()
      raster_path <- paste0("data/", indicator, "/", indicator, "_", pays_id, ".tif")
      shapefile_path <- paste0("data/shapes/regions_", pays_id, ".shp")
      
      if (!file.exists(raster_path) || !file.exists(shapefile_path)) next
      
      rast <- raster::raster(raster_path)
      regions <- sf::st_read(shapefile_path, quiet = TRUE)
      
      valeurs <- exactextractr::exact_extract(rast, regions, 'mean')
      if (tolower(indicator) %in% c("ndvi")) valeurs <- valeurs / 10000
      
      moyenne <- round(mean(valeurs, na.rm = TRUE), 3)
      
      commentaires[[pays]] <- paste0("Le ", pays, "a une valeur moyenne de ", moyenne,
                                     " pour l’indicateur ", toupper(indicator), ".\n")
    }
    
    paste(commentaires, collapse = "\n")
  })
  
  
  
}

