#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(shiny)

shinyServer(function(input, output) {
    
    output$plot1 <-renderPlotly({
        #shinyjs::show("choix")
        
        #departement
        idDep=getId_dep(input$dep)
        idDep=paste("'",idDep,"'",sep = "")
        #mkpi='hosp'
        mkpi=input$kpi
        date_deb=paste("'",input$thedate[1],"'",sep = "")
        date_fin=paste("'",input$thedate[2],"'",sep = "")
        tab=indi
        #req1
        #req1<-paste("select ddate.date,",mkpi," as KPI from tab,ddate where tab.id_date=ddate.id_date and ddate.date between ",date_deb," and ",date_fin)
        req1<-paste("select ddate.date,",mkpi," as KPI from tab,ddate where tab.id_date=ddate.id_date and tab.dep=",idDep," and ddate.date between ",date_deb," and ",date_fin)
        
        #personnalisation du titre pour le graphe
        if(input$kpi=="tx_incid"){
            titre="Taux d'incidence"
        }
        if(input$kpi=="tx_pos"){
            titre="Taux de positivité"
        }
        if(input$kpi=="hosp"){
            titre="Nombre de personnes actuellement hospitalisées"
        }
        if(input$kpi=="rea"){
            titre="Nombre de patients actuellement en réanimation ou en soins intensifs"
        }
        if(input$kpi=="dchosp"){
            titre="Nombre moyen de décès quotidiens à l'hôpital"
        }
        if(input$kpi=="pos"){
            titre="Nombre de personnes déclarées positives (J-3 date de prélèvement)"
        }
        
        dfq1 <- sqldf(req1)
        
        fig <- plot_ly(dfq1, x = ~date, y = ~ KPI, name = input$dep[1], type = 'scatter', mode = 'lines')
        fig <- fig %>% layout(title = titre )
        fig
        
    })
    
    output$plot2 <-renderPlotly({
        #departement
        idDep1=getId_dep(input$dep[1])
        idDep1=paste("'",idDep1,"'",sep = "")
        idDep2=getId_dep(input$dep[2])
        idDep2=paste("'",idDep2,"'",sep = "")
        #choix indicateur
        mkpi=input$kpi
        #range date
        date_deb=paste("'",input$thedate[1],"'",sep = "")
        date_fin=paste("'",input$thedate[2],"'",sep = "")
        
        tab=indi
        
        #req1
        req1<-paste("select ddate.date,",mkpi," as KPI from tab,ddate where tab.id_date=ddate.id_date and tab.dep=",idDep1," and ddate.date between ",date_deb," and ",date_fin)
        
        #req2
        req2<-paste("select ddate.date,",mkpi," as KPI2 from tab,ddate where tab.id_date=ddate.id_date and tab.dep=",idDep2," and ddate.date between ",date_deb," and ",date_fin)
        
        dfq1 <- sqldf(req1)
        dfq2 <- sqldf(req2)
        dt=cbind(dfq1,dfq2$KPI2)
        
        fig <- plot_ly(dt, x = ~date)
        fig <- fig %>% add_trace(y = ~ KPI, name = input$dep[1], type = 'scatter', mode = 'lines')
        fig <- fig %>% add_trace(y = ~ dfq2$KPI2, name = input$dep[2], type = 'bar')
        fig <- fig %>% layout(title = 'Comparaison entre département' )
        fig
        
    })
    
    output$plot3 <-renderPlotly({
        #departement
        if(input$choix=="1"){
            #departement
            idDep=getId_dep(input$dep[1])
            idDep=paste("'",idDep,"'",sep = "")
            date_deb=paste("'",input$thedate[1],"'",sep = "")
            date_fin=paste("'",input$thedate[2],"'",sep = "")
            tab=vaccin
            #req1
            req1<-paste("select ddate.date, n_dose1 as KPI, n_complet as KP2 from tab,ddate where tab.id_date=ddate.id_date and tab.dep=",idDep," and ddate.date between ",date_deb," and ",date_fin)
            
            dfq1 <- sqldf(req1)
            
            fig <- plot_ly(dfq1, x = ~date, y = ~ KPI, name = '1er dose', type = 'scatter', mode = 'lines',colors = "YlOrRd" )
            fig <- fig %>% add_trace(y = ~ KP2, name = '2eme dose', type = 'scatter')
            fig <- fig %>% layout(title = 'Suivi de la vaccination' )
            fig
            
        }else{
            idDep=getId_dep(input$dep[1])
            idDep=paste("'",idDep,"'",sep = "")
            mkpi='nbr_deces'
            date_deb=paste("'",input$thedate[1],"'",sep = "")
            date_fin=paste("'",input$thedate[2],"'",sep = "")
            tab=deces
            #req1
            req1<-paste("select ddate.date,",mkpi," as KPI from tab,ddate where tab.id_date=ddate.id_date and tab.dep=",idDep," and ddate.date between ",date_deb," and ",date_fin)
            
            dfq1 <- sqldf(req1)
            
            fig <- plot_ly(dfq1, x = ~date, y = ~ KPI, name = input$dep[1], type = 'scatter', mode = 'lines',colors = "YlOrRd" )
            fig <- fig %>% layout(title = 'Suivie des décès' )
            fig 
        }

        
    })
    
    output$matable <- renderDataTable({
        
        tempDf <- merge(dep,regions,by='id_region',all.x = TRUE,sort=FALSE)[c('id_dep','nom_dep','region')]
        colnames(tempDf) <- c('dep','nom_dep','region')
        tempDf <- merge(tempDf,indi,by="dep")
        tempDf <- merge(tempDf,ddate,by="id_date")[c('date','nom_dep','region','tx_pos','tx_incid','TO','hosp','rea','dchosp','pos')]
        colnames(tempDf) <- c('DATE','DEPART','REGION','TX POS','TX INCID','TX OCPL','NBR HOSPI','NBR REA','DC HOSP','TEST POS')
        tempDf
    })
    
    output$plot6 <- renderPlotly({
        tempDf <- merge(dep,regions,by='id_region',all.x = TRUE,sort=FALSE)[c('id_dep','nom_dep','region')]
        colnames(tempDf) <- c('dep','nom_dep','region')
        tempDf <- merge(tempDf,indi,by="dep")
        tempDf <- merge(tempDf,ddate,by="id_date")[c('date','nom_dep','region','tx_pos','tx_incid','TO','hosp','rea','dchosp','pos')]
        tempDf <- tempDf[tempDf$date==input$dtr,] #filtrage selon la date
        
        #personnalisation du titre pour le graphe
        if(input$kpi=="tx_incid"){
            titre="Taux d'incidence"
        }
        if(input$kpi=="tx_pos"){
            titre="Taux de positivité"
        }
        if(input$kpi=="hosp"){
            titre="Nombre de personnes actuellement hospitalisées"
        }
        if(input$kpi=="rea"){
            titre="Nombre de patients actuellement en réanimation ou en soins intensifs"
        }
        if(input$kpi=="dchosp"){
            titre="Nombre moyen de décès quotidiens à l'hôpital"
        }
        if(input$kpi=="pos"){
            titre="Nombre de personnes déclarées positives"
        }
        
        #récupérer la colonne désigner par le kpi avec input$kpi
        tempy <- tempDf[,input$kpi]
        
        #construire le graphe
        fig <- plot_ly(tempDf, type='pie', labels = ~ region, values =  tempy , textposition = 'inside')
        fig <- fig %>% layout(uniformtext=list(minsize=12, mode='hide'), title=titre)
        fig
    })
    
    output$mymap <- renderTmap({
        # Recuperer la France Metropolitaine de {rnaturalearth}
        france <- ne_states(country = "France", returnclass = "sf") 
        
        tempDf <- merge(dep,regions,by='id_region',all.x = TRUE,sort=FALSE)[c('id_dep','nom_dep','region','id_region')]
        
        colnames(tempDf) <- c('id_dep','name','region','id_region')
        
        dffrance <- merge(france,tempDf,by='name',all.x = TRUE,sort=FALSE)
        
        madate=getId_date(input$dater)
        
        id1=indi[indi$id_date==madate,]
        
        colnames(id1) <- c('id_dep','id_date','id_region','tx_pos','tx_incid','TO','hosp','rea','dchosp','pos')
        
        Dfinal <- merge(dffrance,id1,by='id_region',all.x = TRUE,sort=FALSE)
        
        Dfinal$id_region <- NULL
        ################################
        
        tmap_mode(mode = "view")
        tmap_options(bg.color = "white", legend.text.color = "white")
        tm_shape(Dfinal) + tm_polygons(col = input$kpi)
    })

})
