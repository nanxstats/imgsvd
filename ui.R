require('shiny')
require('rARPACK')
require('jpeg')
require('png')
require('uuid')

shinyUI(pageWithSidebar(
  
  headerPanel(title = 'ImgSVD - Image Compression via SVD', 
              windowTitle = 'ImgSVD - Image Compression via SVD'),
  
  sidebarPanel(
    includeCSS('boot.css'), 
    includeHTML('header.html'), 
    
    helpText("Step 1. Upload Image"),
    fileInput('file1', 'Upload a PNG / JPEG File:'),
    
    tags$hr(),
    
    helpText("Step 2. Selecting k Singular Values"),
    sliderInput("intk", "Slide to choose k:", min = 1, max = 100, value = 5)
    
  ),
  
  mainPanel(
    
    tabsetPanel(
      
      tabPanel("Let's do this!", 
               h3("Original Image"), 
               tags$hr(), 
               tags$hr(), 
               h3("Compressed Image"), 
               tags$hr(), 
      ), 
      
      tabPanel("Cite this app", 
               imageOutput("originImage", height = "auto"),
               imageOutput("svdImage", height = "auto")
               includeHTML('cite.html')
      )
      
    ),
    
    includeHTML('footer.html')
    
  )
  
))
