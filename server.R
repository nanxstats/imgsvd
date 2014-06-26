require('shiny')
require('rARPACK')
require('jpeg')
require('png')

# Factorize m with k-th order truncated SVD
factorize = function(m, k) {
    
    r = rARPACK::svds(m[, , 1], k)
    g = rARPACK::svds(m[, , 2], k)
    b = rARPACK::svds(m[, , 3], k)
    
    return(list(r = r, g = g, b = b))
    
}

# Recover m using k-th order truncated SVD
recoverimg = function(lst, k) {
    # Recover a single channel
    recover0 = function(fac, k) {
        
        dmat = diag(k)
        diag(dmat) = fac$d[1:k]
        m = fac$u[, 1:k] %*% dmat %*% t(fac$v[, 1:k])
        m[m < 0] = 0
        m[m > 1] = 1
        
        return(m)
        
    }
    
    r = recover0(lst$r, k)
    g = recover0(lst$g, k)
    b = recover0(lst$b, k)
    return(array(c(r, g, b), c(nrow(r), ncol(r), 3)))
}

shinyServer(function(input, output) {
    
    lst = list()
    
    runSVD = reactive({
        
        imgtype = input$file1$type
        
        if (is.null(imgtype)) {
            inFile1 = 'cthd.jpg'
            imgtype = 'image/jpeg'
        } else {
            if (!(imgtype %in% c('image/jpeg', 'image/png'))) {
                stop("Only JPEG and PNG images are supported!")
            }
            inFile1 = input$file1$datapath
        }
        
        isJPEG  = imgtype == 'image/jpeg'
        
        rawimg = (if (isJPEG) jpeg::readJPEG else png::readPNG)(inFile1)
        
        lst = factorize(rawimg, 100)
        lst
    })
    
    doFactorization = reactive({
        
        imgtype = input$file1$type
        
        if (is.null(imgtype)) {
            imgtype = 'image/jpeg'
        } else {
            if (!(imgtype %in% c('image/jpeg', 'image/png'))) {
                stop("Only JPEG and PNG images are supported!")
            }
        }
        isJPEG  = imgtype == 'image/jpeg'
        neig = as.integer(input$intk)
        m    = recoverimg(lst, neig)
        
        outfile2 = tempfile(fileext = ifelse(isJPEG, '.jpg', '.png'))
        (if (isJPEG) jpeg::writeJPEG else png::writePNG)(image = m, target = outfile2, 1)
        
        list('out' = outfile2,
             'k' = neig
        )
    })
    
    output$originImage = renderImage({
        
        lst <<- runSVD()
        list(
            src = if (is.null(input$file1)) 'cthd.jpg' else input$file1$datapath,
            title = "Original Image"
        )
        
    }, deleteFile = FALSE)
    
    output$svdImage = renderImage({
        
        #lst = writeSVD()
        result2 = doFactorization()
        
        list(src = result2$out,
             title = paste("Compressed Image with k = ", as.character(result2$k))
        )
        
    })
    
})
