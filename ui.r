data(mtcars)
minrange<-round(apply(mtcars,2,min),1)
maxrange<-round(apply(mtcars,2,max),1)
factormean<-round(apply(mtcars,2,mean),1)

    shinyUI(pageWithSidebar(
        headerPanel("Predictions of car outcome (mpg)"),
        sidebarPanel(
            h4('Instruccions'),
            h5('This ShinyApp uses mtcars data (more info typing ?mtcars at R software). You just have to choose the dependent variable and enter the value using the attached slider. The app will perform a linear regression of mpg versus the variable and the outcome is a regression plot showing confidence intevals for prediction, and a table with the outcome for the input. This mpg outcome is also showed at the plot.'),
            h4('Input'),
            selectInput("id1", "Car Factor Variable",
                               choices=c("Weight",
                                 "Displacement",
                                 "Horsepower",
                               "Rear_axle_ratio")),
            conditionalPanel(condition="input.id1=='Weight'",
                             sliderInput('value1', 'Please enter the weight value (lb/1000) to predict mpg',value = factormean[6], min = minrange[6], max = maxrange[6], step = 0.1)
            ),
            conditionalPanel(condition="input.id1=='Displacement'",
                             sliderInput('value2', 'Please enter the displacement value (cu.in.) to predict mpg',value = factormean[3], min = minrange[3], max = maxrange[3], step = 0.1)
            ),
            conditionalPanel(condition="input.id1=='Horsepower'",
                             sliderInput('value3', 'Please enter the horsepower value to predict mpg',value = factormean[4], min = minrange[4], max = maxrange[4], step = 0.1)
            ),
            conditionalPanel(condition="input.id1=='Rear_axle_ratio'",
                             sliderInput('value4', 'Please enter the rear axle ratio value to predict mpg',value = factormean[5], min = minrange[5], max = maxrange[5], step = 0.1)
            )
        ),
        mainPanel(
            h3('Prediction'),
            h5('Linear regression prediction, including minimum and maximum value range at a 95% confidence interval'),
            tableOutput("results"),
            h5('Regression plot with confidence intervals for prediction'),
            plotOutput('newPlot')
        )
    
)
)
