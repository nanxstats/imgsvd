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

  writeOrigin = reactive({
    
    if ( is.null(input$file1) ) {
      
      return( list('out1' = 'cthd.jpg') )
      
      } else if ( !is.null(input$file1) ) {
      
        inFile1 = input$file1$datapath
        neig    = as.integer(input$intk)
        
        rawimg = jpeg::readJPEG(inFile1)
        
        outfile1 = paste0('zzz-upload/', gsub(' ', '-', gsub(':', '-', Sys.time())), '-', uuid::UUIDgenerate(TRUE), '.jpg')
        jpeg::writeJPEG(image = rawimg, target = outfile1, 1)
        
        list('out1' = outfile1, 
             'k'    = neig
             )
      
      }
    
  })
  
  writeSVD = reactive({
    
    if ( is.null(input$file1) ) {
      
      return( list('out2' = 'cthd-svd.jpg') )
      
      } else if ( !is.null(input$file1) ) {
        
        inFile1 = input$file1$datapath
        neig    = as.integer(input$intk)
        
        rawimg = jpeg::readJPEG(inFile1)
        
        outfile2 = paste0('zzz-compressed/', uuid::UUIDgenerate(TRUE), '.jpg')
        lst = factorize(rawimg, 100)
        m   = recoverimg(lst, neig)
        jpeg::writeJPEG(image = m, target = outfile2, 1)
        
        list('out2' = outfile2, 
             'k'    = neig
        )
      
      }
    
  })
  
  output$originImage = renderImage({
    
    result1 = writeOrigin()
    
    list(src = result1$out1, 
         contentType = 'image/jpeg',
         alt = "Original Image"
         )
    
    }, deleteFile = FALSE)
  
  output$svdImage = renderImage({
    
    result2 = writeSVD()
    
    list(src = result2$out2, 
         contentType = 'image/jpeg', 
         alt = paste("Compressed Image with k = ", as.character(result2$k))
         )
    
    }, deleteFile = FALSE)
  
})
