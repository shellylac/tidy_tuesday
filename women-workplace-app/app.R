library(shiny)
library(ggplot2)
library(plotly)
library(scales)
library(dplyr)
library(readr)
library(here)

#Load data
jobs_gender <- read_csv(here( "women_in_the_workplace","input_data", "jobs_gender.csv"))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Gender disparity explorer"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("occupation_group",
                        "Major occupation category:",
                        choices = unique(jobs_gender$major_category))
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("jobs_scatter", height = "800px")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    plot_data <- reactive ({
      jobs_gender %>%
        filter(year == 2016) %>%
        filter(total_workers >= 20000) %>%
        filter(major_category %in% input$occupation_group) %>%
        arrange(desc(wage_percent_of_male)) %>%
        mutate(percent_female = workers_female / total_workers,
               wage_percent_female = total_earnings_female / total_earnings_male)
    })

    output$jobs_scatter <- renderPlotly({
      p <- plot_data() %>%
        ggplot(aes(x = percent_female,
                   y = wage_percent_female,
                   size = total_workers,
                   color = minor_category,
                   label = occupation)) +
        geom_point() +
        scale_size_continuous(range = c(1, 10)) + #increases the diff between size classes
        scale_x_continuous(labels = percent_format()) +
        scale_y_continuous(labels = percent_format()) +
        labs(x = "Female workforce proportion (%)",
             y = "Female salaray as % of male",
             title = "Gender disparity and pay gap in 2016" ,
             subtitle = "Only occupations with >20,000 workers") +
        theme_light()

      ggplotly(p)

    })
}

# Run the application
shinyApp(ui = ui, server = server)
