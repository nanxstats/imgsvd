library("shiny")
library("rARPACK")
library("jpeg")
library("png")

# Factorize m with k-th order truncated SVD
factorize = function(m, k) {

  r = rARPACK::svds(m[, , 1], k)
  g = rARPACK::svds(m[, , 2], k)
  b = rARPACK::svds(m[, , 3], k)

  list(r = r, g = g, b = b)

}

# Recover m using k-th order truncated SVD
recover_img = function(lst, k) {

  # Recover a single channel
  recover0 = function(fac, k) {

    dmat = diag(k)
    diag(dmat) = fac$d[1:k]
    m = fac$u[, 1:k] %*% dmat %*% t(fac$v[, 1:k])
    m[m < 0] = 0
    m[m > 1] = 1

    m

  }

  r = recover0(lst$r, k)
  g = recover0(lst$g, k)
  b = recover0(lst$b, k)

  array(c(r, g, b), c(nrow(r), ncol(r), 3))

}

shinyServer(function(input, output) {

  lst = list()

  run_svd = reactive({

    imgtype = input$file1$type

    if (is.null(imgtype)) {
      inFile1 = "demo.jpg"
      imgtype = "image/jpeg"
    } else {
      if (!(imgtype %in% c("image/jpeg", "image/png"))) {
        stop("Only JPEG and PNG images are supported")
      }
      inFile1 = input$file1$datapath
    }

    is_jpeg  = imgtype == "image/jpeg"

    rawimg = (if (is_jpeg) jpeg::readJPEG else png::readPNG)(inFile1)

    lst = factorize(rawimg, 100)
    lst

  })

  do_recovery = reactive({

    imgtype = input$file1$type

    if (is.null(imgtype)) {
      imgtype = "image/jpeg"
    } else {
      if (!(imgtype %in% c("image/jpeg", "image/png"))) {
        stop("Only JPEG and PNG images are supported")
      }
    }

    is_jpeg = imgtype == "image/jpeg"
    neig = as.integer(input$intk)
    m = recover_img(lst, neig)

    outfile2 = tempfile(fileext = ifelse(is_jpeg, ".jpg", ".png"))
    (if (is_jpeg) jpeg::writeJPEG else png::writePNG)(image = m, target = outfile2, 1)

    list("out" = outfile2, "k" = neig)

  })

  output$original_image = renderImage({

    lst <<- run_svd()
    list(
      src = if (is.null(input$file1)) "demo.jpg" else input$file1$datapath,
      title = "Original Image")

  }, deleteFile = FALSE)

  output$svd_image = renderImage({

    # lst = writeSVD()
    result2 = do_recovery()

    list(
      src = result2$out,
      title = paste("Compressed image with k = ", as.character(result2$k))
    )

  })

})
