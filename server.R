install.packages("shiny")
library(shiny)

#Server File for Polyfit App
function(input, output,session) {
  #observeEvent(input$plot,{
  
  observe({
    #x<-seq(input$range[1],input$range[2],(input$range[2]-input$range[1])/(input$m-1))
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
    
    #output$polyout<-renderPrint({summary(poly)})
    
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
      #lines(mse_x,predict(lm(mse~mse_x)),col="red")
    })
  })
}
