# app/app.R
library(shiny)

# If running inside the browser via webR, request supported packages
if (requireNamespace("webr", quietly = TRUE)) {
  webr::install(c("ggplot2", "dplyr"))
}

has_ggplot2 <- requireNamespace("ggplot2", quietly = TRUE)
has_dplyr   <- requireNamespace("dplyr", quietly = TRUE)

# READ DATA (column names: country, Year, renewables_share_energy)
dat <- read.csv("data/renewables.csv", stringsAsFactors = FALSE)

countries <- sort(unique(dat$country))
years_rng <- range(dat$Year, na.rm = TRUE)

ui <- fluidPage(
  titlePanel("Renewable Energy Share Explorer"),
  sidebarLayout(
    sidebarPanel(
      selectInput("countries", "Countries",
                  choices = countries,
                  selected = c("India", "United States"),
                  multiple = TRUE),
      sliderInput("years", "Year range",
                  min = years_rng[1],
                  max = years_rng[2],
                  value = years_rng,
                  step = 1),
      checkboxInput("smooth", "Add linear trend", TRUE),
      downloadButton("dl", "Download filtered CSV")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Explore",
          plotOutput("tsplot", height = "420px"),
          tags$hr(),
          tableOutput("summary")
        ),
        tabPanel("About",
          tags$p("Data: Our World in Data energy compilation (subset bundled with app)."),
          tags$p("Tech: Shiny + Shinylive (webR) for 100% browser execution, deployable to static hosting.")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  filtered <- reactive({
    d <- dat
    d <- d[d$country %in% input$countries &
             d$Year >= input$years[1] & d$Year <= input$years[2], ]
    d
  })

  output$tsplot <- renderPlot({
    d <- filtered()
    if (nrow(d) == 0) return()

    if (has_ggplot2 && has_dplyr) {
      library(ggplot2); library(dplyr)
      p <- d %>%
        rename(share = renewables_share_energy) %>%
        ggplot(aes(x = Year, y = share, color = country)) +
        geom_line(linewidth = 0.9, alpha = 0.9) +
        labs(x = "Year", y = "Renewables (% of energy)", color = "Country") +
        theme_minimal(base_size = 13)
      if (input$smooth) {
        p <- p + geom_smooth(method = "lm", se = FALSE, linetype = "dashed", linewidth = 0.7)
      }
      print(p)
    } else {
      # Base R fallback if ggplot2/dplyr unavailable
      sp <- split(d, d$country)
      yr <- range(d$Year); sh <- range(d$renewables_share_energy, na.rm = TRUE)
      plot(0, 0, type = "n", xlab = "Year", ylab = "Renewables (% of energy)",
           xlim = yr, ylim = sh)
      i <- 1
      for (nm in names(sp)) {
        lines(sp[[nm]]$Year, sp[[nm]]$renewables_share_energy, col = i, lwd = 2)
        if (input$smooth) {
          fit <- lm(renewables_share_energy ~ Year, data = sp[[nm]])
          pred <- data.frame(Year = sp[[nm]]$Year)
          lines(pred$Year, predict(fit, pred), col = i, lty = 2)
        }
        i <- i + 1
      }
      legend("topleft", legend = names(sp), col = seq_along(sp), lwd = 2, bty = "n")
    }
  })

  output$summary <- renderTable({
    d <- filtered()
    if (!nrow(d)) return(NULL)
    aggregate(renewables_share_energy ~ country, d, function(x) {
      c(min = round(min(x, na.rm = TRUE), 2),
        mean = round(mean(x, na.rm = TRUE), 2),
        max = round(max(x, na.rm = TRUE), 2))
    })
  }, rownames = TRUE)

  output$dl <- downloadHandler(
    filename = function() sprintf("renewables_filtered_%s.csv", Sys.Date()),
    content = function(file) write.csv(filtered(), file, row.names = FALSE)
  )
}

shinyApp(ui, server)
