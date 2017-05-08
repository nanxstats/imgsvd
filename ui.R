library("shiny")
library("markdown")

shinyUI(fluidPage(

  title = "ImgSVD: Image Compression via SVD",
  theme = "bootstrap.min.css",

  # css hacks for responsive images
  tags$head(tags$style(
    type="text/css",
    "#original_image img {max-width: 100%; width: 100%; height: auto}"
  )),

  tags$head(tags$style(
    type="text/css",
    "#svd_image img {max-width: 100%; width: 100%; height: auto}"
  )),

  titlePanel("ImgSVD: Image Compression via SVD"),

  tags$hr(),

  fluidRow(
    column(
      width = 6,
      h4("Upload your image"),
      tags$hr(),
      fileInput("file1", "Select a PNG or JPEG file:")
    ),
    column(
      width = 6,
      h4("Select top-k singular values"),
      tags$hr(),
      sliderInput("intk", "Slide to choose k:", min = 1, max = 100, value = 5)
    )
  ),

  tags$hr(),

  fluidRow(
    column(
      width = 6,
      h4("Original Image"),
      tags$hr(),
      imageOutput("original_image", height = "auto")),
    column(
      width = 6,
      h4("Compressed Image"),
      tags$hr(),
      imageOutput("svd_image", height = "auto")
    )
  ),

  tags$hr(),

  fluidRow(
    column(
      width = 12,
      includeMarkdown("footer.md")
    )
  )

))
