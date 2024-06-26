# Polyfit 〰️

Interactive tool for visualizing curve fitting using polynomials using R Shiny.  

This is originally created for the article about Polynomial Regression on [Medium](https://medium.com/@stevenlio/polynomial-regression-%EF%B8%8F-e0e20bfbe9d5)

You can find the project page [here](https://stevenlio88.github.io/Portfolio/projects/polyfit/)

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*Ody0Ez0-VYDRF6eomVYJeg.gif)

[Launch App](https://stevenlio.shinyapps.io/polyfit/)

---
## Details:

A R Shiny application to visualize linear regression results using only polynomials up to degree(n).

### Parameters: 
**Function** - Equation of the function *y = f(x)* to be fitted  
**Value Range for x** - The range of *x* values to be used to generate the data points  
**Number of Points** - The total number of point pairs *(x, y)* to be generated  
**Set Seed for Noise RNG** - Set the seed for Random Number Generator on noise for reproducible results  
**Variance Level for Noise** - The amount of noise to be added to each data pair  
**Max Polynomial Degree Fitted** - The maximum degree (n) of polynomial used to approximate the function  

---
## How to
You may need the R package shiny to run this app.  
Run the following in R to install the shiny package:  

```
install.packages("shiny")  
library(shiny)  
```
Then run the following: 
```
runGitHub("Polyfit","stevenlio88")
```
---

![](https://komarev.com/ghpvc/?username=stevenlio88&color=grey)

