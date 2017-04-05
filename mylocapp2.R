setwd("~/Documents/UCD/BA Prac/gloc_globe")
require(shiny)
devtools::install_github("bwlewis/rthreejs")
require(threejs)


library("maptools")
library("maps")
data(wrld_simpl, package="maptools")


shinyApp(
  ui = fluidPage(
    globeOutput("GlobeOut",width="100%",height="750px")
    # absolutePanel(top=10,right=25, 
    #               sliderInput("year", "Year:",min= 1991, max=2016, step=1 ,animate=animationOptions(loop= F,interval=500),value=1990,sep=""),
    #               checkboxInput("legend", "Display legend", TRUE),
    #               tags$div(class="header", checked=NA,
    #                        tags$p("The Circle Markers indicate population increase"),tags$p("The Colors indicate the pop. growth in percentages"))
    ),
  server = function(input, output) {
    load("myloc3.Rdata")
    #earth <- system.file("images/world.jpg", package="threejs")
    
    bgcolor <- "#000025"
    earth <- tempfile(fileext=".jpg")
    jpeg(earth, width=2048, height=1024, quality=100, bg=bgcolor, antialias="default")
    par(mar = c(0,0,0,0), pin = c(4,2), pty = "m", xaxs = "i",
        xaxt = "n", xpd = FALSE, yaxs = "i", yaxt = "n")
    
    col <- rep("black",length(wrld_simpl$NAME))    # Set a default country color
    
    col[wrld_simpl$NAME %in% unique(ds$ctry,na.rm=T)] <- "#003344"    # Highlight countries visited
    
    
    plot(wrld_simpl, col=col,
         bg=bgcolor, border="#111111", ann=FALSE,  axes=FALSE, 
         xpd=FALSE,  xlim=c(-180,180), ylim=c(-90,90),  setParUsrBB=TRUE)
    
    graphics.off()
    
    # bgcolor <- "#000025"
    # earth <- tempfile(fileext=".jpg")
    # jpeg(earth, width=2048, height=1024, quality=100, bg=bgcolor, antialias="default")
    # par(mar = c(0,0,0,0), pin = c(4,2), pty = "m", xaxs = "i", xaxt = "n", xpd = FALSE, yaxs = "i", yaxt = "n")
    
    ds<- ds[,c(2,3,8,9,1,7)]
    
    output$GlobeOut <- renderGlobe({
      args <- c(earth, list(lat=ds[,1], long=ds[,2], arcs=ds[,c(1:4)], value = 100*ds[,6]/max(ds[,6]), arcsHeight=0.3, arcsLwd=2, arcsColor="#ffff00", arcsOpacity=0.15, atmosphere=TRUE))
      do.call(globejs, args=args)
    })
  })
