# ImgSVD

ImgSVD is a Shiny application for image compression via singular value decomposition (SVD).

## Introduction

This application is inspired by Yihui Xie's comment in Yixuan Qiu's [article](https://cos.name/2014/02/svd-and-image-compression/) on image compression via singular value decomposition with the R package [rARPACK](https://cran.r-project.org/package=rARPACK).

## Deploy

To run ImgSVD locally, simply run the following from terminal:

```bash
git clone https://github.com/road2stat/imgsvd.git
R -e "shiny::runApp('~/imgsvd/', launch.browser = TRUE)"
```

and you are all set. Note that these packages should be installed first:

```r
install.packages(c("shiny", "markdown", "rARPACK", "jpeg", "png"))
```

Currently, ImgSVD supports input images in JPEG/PNG format.
