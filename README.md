# ImgSVD

ImgSVD is a Shiny app for image compression via singular value decomposition (SVD).

## Introduction

The ImgSVD app is inspired by Yihui Xie's comment in Yixuan Qiu's [article](http://cos.name/2014/02/svd-and-image-compression/) on image compression via singular value decomposition with the R package [rARPACK](http://cran.r-project.org/web/packages/rARPACK/).

## Deploy

To deploy ImgSVD locally, simply run the following from terminal:

    git clone https://github.com/road2stat/imgsvd.git
    R -e "shiny::runApp('~/imgsvd/', launch.browser = TRUE)"

and it's ready to go. Note that the depended packages should be installed first in R:

    install.packages(c('shiny', 'rARPACK', 'jpeg', 'png'))

Currently ImgSVD supports images in JPEG / PNG format.

## References

 [1] Yixuan Qiu. (2014). [Singular Value Decomposition and Image Compression](http://cos.name/2014/02/svd-and-image-compression/).
