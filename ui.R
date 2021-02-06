#UI File for Polyfit App
fluidPage(
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
