library(DT)
library(shiny)
library(shinydashboard)

shinyUI(
  dashboardPage(
    skin = "black",
    dashboardHeader(title = "WHO Immunization Record for 1-year-olds",
                  titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("archive")),
      convertMenuItem(menuItem("Global", tabName = "global", icon = icon("globe-americas"),
               selectizeInput(
                 inputId = "selectedVax",
                 label = "Select Vaccine: ",
                 choices = unique(all_vax$vax),
                 multiple = FALSE),
               selectizeInput(
                 inputId = "selectedYear",
                 label = "Select Year:",
                 choices = unique(all_vax$year),
                 multiple = FALSE)), "global"
               ),
      convertMenuItem(menuItem("Countries", tabName = "country", icon = icon("map"),
               selectizeInput(
                 inputId = "selectedCountry",
                 label = "Select Country:",
                 choices = sort(unique(all_vax$Country)),
                 multiple = FALSE)), "country"
               ),
      convertMenuItem(menuItem("Compare", tabName = "compare", icon = icon("balance-scale"),
               selectizeInput(
                 inputId = "country1",
                 label = "Select Country:",
                 choices = sort(unique(all_vax$Country)),
                 multiple = FALSE),
      
               selectizeInput(
                 inputId = "country2",
                 label = "Select Country2:",
                 choices = sort(unique(all_vax$Country)),
                 select = "United States",
                 multiple = FALSE), 
               selectizeInput(
                 inputId = "compareYear",
                 label = "Select Year:",
                 choices = unique(all_vax$year),
                 multiple = FALSE)), "compare"
               ),
      
      menuItem("Data", tabName = "data", icon = icon("database"))
      )),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview", 
              h2("Description of the Dataset"),
              htmlOutput("overview")
      ),
      tabItem(tabName = "global",
              fluidRow(box(htmlOutput("map"), width = 12)),
              fluidRow(box(plotOutput("bottom10"), width = 12)),
              fluidRow(box(DT::dataTableOutput("bottomData"), width = 12))
              ),
      tabItem(tabName = "country", 
              fluidRow(box(plotOutput("country"), width = 12))
              ),
      tabItem(tabName = "compare",
              fluidRow(box(plotOutput("compare"), width = 12))),
      tabItem(tabName = "data", 
              fluidRow(box(DT::dataTableOutput("data"), width = 12)))
    )
  )
))
