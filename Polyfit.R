#Clear Work Space
rm(list = ls())
cat("\014")

#Install / Load Essentials
packages = c("ggplot2","shiny")
memory.size(max = T)

## Now load or install&load all
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)



ui <- fluidPage(
  titlePanel("Visualize Polyfit"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("formula","Input Your Function y=f(x)", value = "x*sin(3*x)+x^2*cos(2*x)"),
      sliderInput("range","Value Range for x",min=-50,max=50,step=0.1,value=c(-17,15)),
      sliderInput("m","Number of Points",2,500, 100),
      numericInput("seed","Set Seed for Noise RNG", 100, min = 1, max = 1000, step = 1),
      sliderInput("s","Variance Level for Noise",0,1,0,step=0.1),
      sliderInput("d","Max Polynomial Degree Fitted",min=0,max=100, value=2,animate=animationOptions(interval=150,loop=TRUE))
      #,actionButton("plot","Calculate", class = "btn-success")
      ,width=3),
    mainPanel(
      tabsetPanel
      (
        type="tabs",
        tabPanel("Plot",
                 sliderInput("xaxis","Plot X Axis Range",min=-50,max=50,step=0.1,value=c(-17,15)),
                 actionButton("resetplot","Reset Plot Area", class = "btn-success"),
                 checkboxInput("ressig","Show Errors",T),
                 h3("Scatter Plot"),
                 plotOutput(outputId = "distPlot"),
                 
                 h3("Least Squared Regression Summary"),
                 verbatimTextOutput("polyout")
        ),
        tabPanel("Residual Plots",
                 plotOutput(outputId = "resid"),
                 plotOutput(outputId = "msedegree")
        ),
        tabPanel("Data"
                 ,tableOutput("table")
        )
      )
    )
  )
)

server <- function(input, output,session) {
  observe({
    x<-seq(input$range[1],input$range[2],0.001)
    
    res<-try(eval(parse(text=paste0("0+",input$formula))),silent=T)
    validate(
      need(class(res)!="try-error", "Mistake in Formula")
    )
    
    set.seed(input$seed)
    y2<-eval(parse(text=paste0("0+",input$formula)))
    
    if(length(y2)!=length(x)){y2<-rep(y2,length(x))}
    
    x<-x[which(!(is.na(y2))&abs(y2)!=Inf)]
    y2<-y2[which(!(is.na(y2))&abs(y2)!=Inf)]
    y<-y2+rnorm(length(x),0,input$s*(10^(round(log(max(abs(y2)),base=10)))))
    
    
    idx<-sort(sample(seq(1,length(x)),input$m,replace=F))  
    x<-x[idx]
    y2<-y2[idx]
    y<-y[idx]
    
    z<-matrix(data=NA, nrow=length(x), ncol=input$d+1)
    
    for(j in 1:ncol(z))
    {
      z[,j] <- x^(j-1)
    }
    
    poly<-lm(y~z[,1:(input$d+1)])
    
    output$polyout<-renderPrint({summary(poly)})
    
    output$distPlot <- renderPlot({
      par(xpd=T)
      plot(x,y,xlim=input$xaxis,cex.axis=1.2,cex.lab=1.2,cex.main=2.5) #,main="Scatter Plot"
      lines(x,y2,col="grey")
      lines(x,predict(poly),col="blue",lty=2)
      legend("topright", inset=c(0,-0.15)
             ,legend=c(paste0("y=",input$formula), paste0("Polynomial Degree ",input$d)),
             col=c("grey", "blue"), lty=1:2,box.lty=0)
      if(input$ressig){segments(x,y,x,predict(poly),col="pink",lty=2)}
    })
    
    output$table<-renderTable({cbind(z,y=y,yhat=predict(poly))})
    
    observeEvent(input$resetplot,{
      updateSliderInput(session,"xaxis",value=input$range)
    })
    
    output$resid<-renderPlot({
      plot(predict(poly),resid(poly),xlab="Fitted Values",ylab="Residuals",main="Fitted vs. Residual"
           ,cex.axis=1.2,cex.lab=1.2,cex.main=2.5)
      abline(0,0)
    })
    
    output$msedegree<-renderPlot({
      mse_x<-seq(0,input$d,1)
      mse<-c()
      
      for(j in 1:ncol(z))
      {
        mse[j]<-mean(resid(lm(y~z[,1:j]))^2)
      }
      
      plot(mse_x,mse,xlab="Polynomial Degree",ylab="MSE",main="Polynomial Degree vs. MSE",type="o"
           ,cex.axis=1.2,cex.lab=1.2,cex.main=2.5,col="red",xaxt="n")
      axis(1,at=seq(0,input$d,1))
      abline(0,0)
    })
  })
}

shinyApp(ui, server)











