library(DT)
library(shiny)
library(googleVis)

shinyServer(function(input, output, session){
  
   observe({
    updateYear <- unique(all_vax %>%
                     filter(., all_vax$vax == input$selectedVax) %>%
                     .$year)
    updateSelectizeInput(
      session, "selectedYear",
      choices = updateYear,
      selected = updateYear[1])

   })
  
  globalData <- reactive({
     req(input$selectedVax)
     req(input$selectedYear)
    all_vax %>% filter(., vax == input$selectedVax & year == input$selectedYear)
  })
  
  output$bottomData <- renderDataTable({
    datatable(globalData() %>% arrange(., vax_rate) %>% head(., 50), rownames=TRUE,
              caption = "50 Countries with the Lowest Vaccination Rates")
  })
  
  output$map <- renderGvis({
    gvisGeoChart(globalData(), locationvar = "Country", colorvar = "vax_rate",
                 options=list(region="world", displayMode="regions",
                              resolution="countries", colorAxis = "{colors : ['red', 'green']}",
                              backgroundColor="lightblue",
                              keepAspectRatio = TRUE,
                              width="auto", height="auto"))
  })
  
  output$bottom10 <- renderPlot({
    bot10  <- globalData() %>% filter(., vax == input$selectedVax & year == input$selectedYear) %>%
      arrange(., vax_rate) %>% head(., 10)
    ggplot(bot10, aes(x = reorder(Country, vax_rate), y = vax_rate)) + 
      geom_col(fill = "lightblue") + 
      ggtitle("10 Countries with the Lowest Vaccination Rates") + 
      ylab(paste0(input$selectedVax, " Vaccination Rates in ", input$selectedYear)) +
      xlab("Countries")
  })
  
  output$country <- renderPlot ({
    countryData <- reactive({
      req(input$selectedCountry)
      all_vax %>% filter(., all_vax$Country == input$selectedCountry)
    })
    ggplot(countryData(), aes(x = year, y = vax_rate, color = vax, group = vax)) + 
      geom_point()+ geom_line(stat = "identity") +
      ggtitle(paste0("Immunization Rate by year for ", input$selectedCountry)) +
      xlab("Year") + ylab("Immunization rate (%)") + 
      scale_x_continuous(breaks=seq(1980,2018,by = 5))}, 
    height = "auto", width = "auto")
  
  output$compare <- renderPlot ({
    compareData <- reactive({
      req(input$country1)
      req(input$country2)
      req(input$compareYear)
      country_subset <- c(input$country1, input$country2)
      all_vax %>% filter(., all_vax$year == input$compareYear & Country %in% country_subset)
    })
    ggplot(compareData(), aes(x = vax, y = vax_rate, fill = Country, group = Country)) +
      geom_histogram(stat = "identity", position = "dodge") +
      ggtitle(paste0("Comparing Vaccine Rates Between ", input$country1, " and ", input$country2, " in ", input$compareYear)) +
      xlab("Vaccine") +
      ylab("Relative Vaccine Rates")

  })
  
  output$data <- renderDataTable({
    datatable(all_vax, rownames=FALSE)
  })
  
  output$overview <- renderUI({
    rawText <- readLines('info.txt')
    rawText<- paste(rawText, collapse = "")
    return(HTML(rawText))
  })
})

