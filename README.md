# ImgSVD <img src="logo.png" align="right" alt="logo" height="180" width="180" />

ImgSVD is a Shiny application for image compression via singular value decomposition (SVD). This application is inspired by Yihui Xie's comment in Yixuan Qiu's [article](https://cos.name/2014/02/svd-and-image-compression/) on image compression via singular value decomposition with the R package [rARPACK](https://cran.r-project.org/package=rARPACK).

## Play with it

To run this Shiny app locally, install the following R packages first:

```r
install.packages(c("shiny", "markdown", "rARPACK", "jpeg", "png"))
```

then use:

```r
shiny::runGitHub("road2stat/imgsvd")
```

Currently, ImgSVD supports input images in JPEG or PNG format.
