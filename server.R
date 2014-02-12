require('shiny')
require('rARPACK')
require('jpeg')
require('png')
require('uuid')

factorize = function(m, k) {
  
  r = rARPACK::svds(m[, , 1], k)
  g = rARPACK::svds(m[, , 2], k)
  b = rARPACK::svds(m[, , 3], k)
  
  return(list(r = r, g = g, b = b))

}

recoverimg = function(lst, k) {
  
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
  m = array(0, c(nrow(r), ncol(r), 3))
  m[, , 1] = r
  m[, , 2] = g
  m[, , 3] = b
  
  return(m)
  
}

shinyServer(function(input, output) {

  writeSVD = reactive({
    
    if ( is.null(input$file1) ) {
      
      return( list('out' = 'cthd-svd.jpg',
                   'tp' = 'image/jpeg',
                   'k' = 20L) )
      
        
      } else {
        imgtype = input$file1$type
        inFile1 = input$file1$datapath
        neig    = as.integer(input$intk)
        
        if ( imgtype == 'image/jpeg' ) {
          
          rawimg = jpeg::readJPEG(inFile1)
          
          outfile2 = paste0('zzz-compressed/', uuid::UUIDgenerate(TRUE), '.jpg')
          lst = factorize(rawimg, 100)
          m   = recoverimg(lst, neig)
          jpeg::writeJPEG(image = m, target = outfile2, 1)
          
          } else if ( imgtype == 'image/png' ) {
            
            rawimg = png::readPNG(inFile1)
            
            outfile2 = paste0('zzz-compressed/', uuid::UUIDgenerate(TRUE), '.png')
            lst = factorize(rawimg, 100)
            m   = recoverimg(lst, neig)
            png::writePNG(image = m, target = outfile2, 1)
            
            } else {
              
              return( list('out' = 'cthd-svd.jpg',
                           'tp' = 'image/jpeg',
                           'k' = 20L) )
            
            }
        
        list('out' = outfile2, 
             'tp' = imgtype, 
             'k' = neig
             )
      
      }
    
  })
  
  output$originImage = renderImage({

    list(
      src = if (is.null(input$file1)) 'cthd.jpg' else input$file1$datapath,
      alt = "Original Image"
    )

  }, deleteFile = FALSE)

  output$svdImage = renderImage({
    
    result2 = writeSVD()
    
    list(src = result2$out, 
         contentType = result2$tp, 
         alt = paste("Compressed Image with k = ", as.character(result2$k))
         )
    
    }, deleteFile = FALSE)
  
})
