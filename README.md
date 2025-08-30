# 🌱 Renewable Energy Share Explorer

[![Shiny](https://img.shields.io/badge/built%20with-Shiny-0073B7.svg)](https://shiny.posit.co/)
[![R](https://img.shields.io/badge/R-4.3.0%2B-276DC3.svg)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An interactive R Shiny dashboard for visualizing the share of primary energy consumption from renewable sources across various countries and years.

---

## 🚀 Live Demo

**[View the live application here](https://saurabhkirve.shinyapps.io/renewable-dashboard/)**



---

## 📸 Screenshot

<img width="1896" height="888" alt="image" src="https://github.com/user-attachments/assets/15c6fb97-c46d-4ad5-99a1-8c1a21afbecd" />




---

## 📖 About The Project

This application provides an intuitive and interactive platform for users to explore and compare renewable energy trends globally. By leveraging data from "Our World in Data," it allows for deep dives into how different nations are transitioning towards sustainable energy sources. The user-friendly interface is designed for researchers, students, and policymakers alike.

---

## ✨ Features

* **Interactive Time-Series Plot**: Visualize renewable energy share over time using a dynamic `plotly` chart. Hover for details, zoom, and pan.
* **Multi-Country Comparison**: Select and compare multiple countries simultaneously on the same graph.
* **Dynamic Year Range Slider**: Easily filter the data to focus on specific time periods.
* **Toggleable Trend Line**: Add a LOESS smoothed trend line to visualize the overall trajectory.
* **Key Metric Value Boxes**: See at-a-glance statistics like the highest recorded share and the latest year's average.
* **Interactive Data Table**: View summary statistics (min, max, average) in a sortable and searchable `reactable` table.
* **Data Download**: Download the currently filtered data as a CSV file for offline analysis.
* **Modern & Responsive UI**: Built with `{bslib}` for a clean look that works on both desktop and mobile devices.

---

## 🛠️ Technology Stack

This project is built entirely in the R ecosystem, leveraging a suite of powerful packages:

* **Core Framework**: `{shiny}`
* **UI & Theming**: `{bslib}`, `{bsicons}`
* **Data Manipulation**: `{dplyr}`
* **Plotting**: `{ggplot2}` & `{plotly}`
* **Interactive Tables**: `{reactable}`

---

## ⚙️ Getting Started

To run this application on your local machine, follow these steps.

### Prerequisites

* **R**: Version 4.1.0 or newer.
* **RStudio**: A recent version of the RStudio IDE is highly recommended.

### Installation

1.  **Clone the repository** (or download the source code):
    ```sh
    git clone [https://github.com/Sxurabh/renewable-energy-insights-dashboard.git]
    ```

2.  **Open the project** in RStudio by opening the `app.R` file.

3.  **Install the required R packages** by running the following command in the R console:
    ```r
    install.packages(c("shiny", "bslib", "dplyr", "ggplot2", "plotly", "reactable", "bsicons"))
    ```

4.  **Run the application**:
    Click the "Run App" button in the RStudio editor, or run the following command in the console:
    ```r
    shiny::runApp('app.R')
    ```

---

## ☁️ Deployment

This application is designed for easy deployment on [shinyapps.io](https://www.shinyapps.io/). The deployment process is managed by the `{rsconnect}` package.

The `app.R` file is self-contained and loads data from a remote URL, ensuring that no local data files are needed for the deployment bundle.

---

## 📊 Data Source

The data used in this application is sourced from **Our World in Data**, specifically from their collection on Renewable Energy.

* **Source**: [Our World in Data - Renewable Energy](https://ourworldindata.org/renewable-energy)
* **Citation**: Hannah Ritchie, Pablo Rosado and Max Roser (2022) - "Renewable Energy". Published online at OurWorldInData.org.

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.
