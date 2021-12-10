# Define UI for application
shinyUI(fluidPage(
    #selection du thème
    #shinythemes::themeSelector(),
    useShinyjs(),
    theme = shinytheme("sandstone"),
    # Application title
    titlePanel("Informations Covid-19"),

    # subdivison de l'interface
    sidebarLayout(
        sidebarPanel(
            #choix département
            selectInput("dep", label = h4("Département(s)"), 
                        choices= levels(name_dep),
                        multiple = T,
                        selected = NULL),
            #gestion date
            dateRangeInput("thedate", label=h4("Plage temps"), 
                           start = "2021-03-2", 
                           end = "2021-07-30",
                           format = "yyyy-mm-dd", startview = "month", separator = " to "),
            #choix de l'indicateur
            radioButtons("kpi", label = h4("L'indicateur"),
                         choices = list("Taux d’incidence" = "tx_incid", 
                                        "Taux de positivité" = "tx_pos", 
                                      #  "Taux d’occupation" = "TO",
                                        "Nombre d’hospitalisation" = "hosp",
                                        "Nombre de réanimation" = "rea",
                                        "Nombre de décès COVID19" = "dchosp",
                                        "Tests positifs" = "pos"
                                      ), 
                         selected = "tx_incid"),
            #terme de comparaison
            radioButtons("choix", label = h5("L'épidémie en fonction :"),
                         choices = list("Vaccin"="1","Décès"="2"),
                         selected = "1")
        
        ),

        # Show the plots
        mainPanel(
            useShinyjs(),
            tabsetPanel(
                tabPanel("Graphe", plotlyOutput("plot1"),plotlyOutput("plot3")),
                tabPanel("Carte", 
                         dateInput("dater", 
                                   label = h5("Sélectionner la date :"), 
                                   value = "2021-04-01"),
                         tmapOutput("mymap")
                ),
                tabPanel("SVD", plotlyOutput("plot2")),
                tabPanel("SVR", 
                         dateInput("dtr", 
                                   label = h6("Sélectionner la date :"), 
                                   value = "2021-04-01"),
                         plotlyOutput("plot6")),
                tabPanel(id="test","Recherche",dataTableOutput("matable"))
            )
        )
    )
))
