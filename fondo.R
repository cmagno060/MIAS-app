#######################################################################
#     #FOR INSTALL "EBImage"
#######################################################################
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#
#BiocManager::install("EBImage")
# #Restart R
#browseVignettes("EBImage")
#######################################################################

library("EBImage")

if(!dir.exists("fondo")){dir.create("fondo")}

for(i in 1:322){
  if(i<10){
    id=paste0("mdb00",i)
  }else{
    if(i<100){
      id=paste0("mdb0",i)
    }else{id=paste0("mdb",i)}
  }
  dbimage=readImage(paste0("all-mias/",id,".png"))
  #display(dbimage)
  
  binimage=dbimage>otsu(dbimage,levels=2^16)
  binimage=EBImage::opening(binimage,
                            kern=makeBrush(15,shape="disc"))
  #display(binimage)
  setwd("fondo")
  writeImage(binimage,paste0(id,"bin.png"))
  setwd("..")
  binsegments<-bwlabel(binimage)
  #display(colorLabels(binsegments))
  allsegments<-1:max(binsegments)
  segnum<-as.numeric(names(sort(table(binsegments)[-1],
                                 decreasing=T)[1]))
  segmentsdeleted<-list(allsegments[!allsegments %in% segnum])
  workedimage=combine(binsegments)
  mask=rmObjects(workedimage,segmentsdeleted,reenumerate=F)
  setwd("fondo")
  writeImage(mask,paste0(id,"mask.png"))
  setwd("..")
}