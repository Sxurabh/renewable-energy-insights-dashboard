library(shiny)
library(bslib)
if (requireNamespace("webr", quietly = TRUE)) {
  webr::install(c("ggplot2", "dplyr", "bslib"))
}
has_ggplot2 <- requireNamespace("ggplot2", quietly = TRUE)
has_dplyr   <- requireNamespace("dplyr", quietly = TRUE)

dat <- read.csv("data/renewables.csv", stringsAsFactors = FALSE)
countries <- sort(unique(dat$country))
years_rng <- range(dat$Year, na.rm = TRUE)

ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bootswatch = "cosmo",
    primary = "#009879",
    base_font = "Arial",         # The truly universal font, always present
    heading_font = "Arial"
  ),
  titlePanel(tags$h2("🌱 Renewable Energy Share Explorer", 
                     style="font-weight:700; letter-spacing:1px;")),
  sidebarLayout(
    sidebarPanel(
      tags$h4("Filter by"),
      selectInput("countries", "Select countries", choices = countries,
        selected = c("India", "United States"), multiple = TRUE),
      tags$strong("Year range"),
      sliderInput("years", NULL, min = years_rng[1], max = years_rng[2],
                  value = years_rng, step = 1),
      tags$br(),
      checkboxInput("smooth", "Add trend line", TRUE),
      tags$hr(),
      downloadButton("dl", "Download filtered data", class = "btn-primary btn-block")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Explore",
          card(
            card_header("Trends Over Time"),
            plotOutput("tsplot", height = "550px")
          ),
          tags$br(),
          card(
            card_header("Summary Table"),
            tableOutput("summary")
          )
        ),
        tabPanel("About",
          tags$div(
            style = "max-width: 700px; margin: auto;",
            tags$h3("About this App"),
            tags$p("This dashboard visualizes renewable energy shares over time using open data from Our World in Data."),
            tags$ul(
              tags$li("100% browser-run Shiny app (no server needed)"),
              tags$li("Free hosting via GitHub Pages using Shinylive & webR"),
              tags$li("Source data: Our World in Data - Renewables share"),
              tags$li("Created by [Your Name]"),
              tags$li(a("Connect on LinkedIn", href="https://linkedin.com/in/yourhandle", target="_blank"))
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  filtered <- reactive({
    d <- dat
    d <- d[d$country %in% input$countries & d$Year >= input$years[1] & d$Year <= input$years[2], ]
    d
  })

  output$tsplot <- renderPlot({
    if (!(has_ggplot2 && has_dplyr)) {
      plot.new()
      text(0.5, 0.5, "Visualization error:\nMissing required packages (ggplot2/dplyr).\nPlease reload or contact the developer.", cex = 1.2)
      return()
    }
    d <- filtered()
    if (nrow(d) == 0) {
      plot.new()
      text(0.5, 0.5, "No data to display.", cex = 1.4)
      return()
    }
    library(ggplot2)
    library(dplyr)
    p <- d %>%
      rename(share = renewables_share_energy) %>%
      ggplot(aes(x = Year, y = share, color = country)) +
      geom_line(linewidth = 1.3, alpha = 0.92) +
      theme_minimal(base_family = "Arial", base_size = 15) +
      scale_color_brewer(palette = "Set2") +
      labs(
        x = "Year",
        y = "Renewables (% of energy)",
        color = NULL,
        title = paste("Renewable Energy in", paste(input$countries, collapse=", "))
      ) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.1),
        legend.position = "top"
      )
    if (input$smooth) {
      p <- p + geom_smooth(method = "lm", se = FALSE, linetype = "dashed",
                           color = "#555555", linewidth = 0.85)
    }
    print(p)
  })

  output$summary <- renderTable({
    d <- filtered()
    if (!nrow(d)) return(NULL)
    by_country <- aggregate(renewables_share_energy ~ country, d, function(x) {
      min = round(min(x, na.rm = TRUE), 2)
      mean = round(mean(x, na.rm = TRUE), 2)
      max = round(max(x, na.rm = TRUE), 2)
      c(Min = min, Mean = mean, Max = max)
    })
    res <- data.frame(
      Country = by_country$country,
      Min = by_country$renewables_share_energy[,1],
      Mean = by_country$renewables_share_energy[,2],
      Max = by_country$renewables_share_energy[,3]
    )
    res
  })

  output$dl <- downloadHandler(
    filename = function() sprintf("renewables_filtered_%s.csv", Sys.Date()),
    content = function(file) write.csv(filtered(), file, row.names = FALSE)
  )
}

shinyApp(ui, server)
