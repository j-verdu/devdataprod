library(shiny)

data(mtcars)
cars<-mtcars
names(cars)[3:6]<-c("Displacement (cu.in.)", "Horsepower", "Rear_axle_ratio", "Weight (lb/1000)")
shinyServer(
    function(input, output) {
        
        output$oid1 <- renderPrint({input$id1})
        output$ovalue <- renderPrint({input$value})
        
        # Get factor variable as reactive
        datasetInput <- reactive({
            switch(input$id1,
                   "Displacement" = 3,
                   "Horsepower" = 4,
                   "Rear_axle_ratio" = 5,
                   "Weight"= 6,
                   )
        })
        dataValue<- reactive({
            if(input$id1=="Weight") {as.numeric(input$value1)}
            else if(input$id1=="Displacement") {as.numeric(input$value2)}
            else if(input$id1=="Horsepower") {as.numeric(input$value3)}
            else if(input$id1=="Rear_axle_ratio") {as.numeric(input$value4)}
        })
        
        output$newPlot <- renderPlot({
            
            name<-names(cars)[as.integer(datasetInput())]
            datacars<-data.frame(mpg=cars$mpg,input=as.vector(cars[,as.integer(datasetInput())]))
            # fit model
            fit<-lm(mpg~input,data=datacars)
            # plot points and model
            plot(datacars$input,datacars$mpg, xlab=name, ylab='Miles per Gallon',
                 ylim=c(0.5*min(datacars$mpg),1.2*max(datacars$mpg)),col='black',
                 bg='grey',pch=21,cex=1.5)
            abline(fit,lwd=2,col=2)
            ## confidence interval lines
            newx <- seq(min(datacars$input), max(datacars$input), 0.1)
            newx2<-data.frame(input=newx)
            a <- predict(fit, newdata=newx2, interval="prediction")
            lines(newx, a[,2], lty=2)
            lines(newx, a[,3], lty=2)
            ## Value prediction
            topredict <- dataValue()
            topred2<-data.frame(input=topredict)
            out <- predict(fit, newdata=topred2, interval="prediction")
            points(rep(topredict,3),as.vector(out),pch=21,col='black',bg=c('green','red','red'),cex=3)
            
            output$results <- renderTable({
                prediction<-cbind(topredict,out)
                colnames(prediction)<-c(name,"MPG Prediction","Minimum MPG","Maximum MPG")
                prediction<-round(prediction,digits=1)
                
            })
        })
        
        
        
        output$pred <- renderPrint({out[1,1]})
        output$predmin <- renderPrint({out[1,2]})
        output$predmax <- renderPrint({out[1,3]})
    }
)

