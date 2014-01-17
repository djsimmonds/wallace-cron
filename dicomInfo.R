path <- "/home/simmondsdj/COG"
pathSources <- paste("/data/Luna1/Raw", c("BIRC", "NIC"), sep="/")
setwd(path)

bircID <- scan("BIRC_ID")
bircID <- ifelse(nchar(bircID)==11, paste(0, bircID, sep=""), bircID) # scan removes leading zero for subjects scanned before 2010
lunaID <- scan("LUNA_ID")
scanDate <- scan("SCAN_DATE")

DICOM_INFO <- sapply(1:length(bircID), function(i){
  src <- paste(pathSources, bircID[i], sep="/")
  src <- src[file_test("-d", src)]
  if(length(src)==0){
    "NO DIRECTORY FOUND IN SOURCE"
  }else if(length(src)==2){
    "FOUND IN BOTH DIRECTORIES, IGNORING FOR NOW"
  }else{
    d <- dir(src)
    d <- d[file_test("-d", file.path(src, d))]
    label <- sapply(1:length(d), function(j) {
      dcmFile <- Sys.glob(file.path(src, d[j], "*.dcm"))[1]
      cmd <- paste("dicom_hdr", dcmFile, "| grep 'ID Series Description' | cut -d/ -f5")
      label <- system(cmd, intern=T)
      if(length(label)==0) label <- ""
      label
    })
    label2 <- sapply(1:length(d), function(j) {
      dcmFile <- Sys.glob(file.path(src, d[j], "*.dcm"))[1]
      cmd <- paste("dicom_hdr", dcmFile, "| grep 'Protocol Name' | cut -d/ -f5")
      label <- system(cmd, intern=T)
      if(length(label)==0) label <- ""
      label
    })
    cbind(d, label, label2)
  }
})

save(DICOM_INFO, file="DICOM_INFO")

load("DICOM_INFO")
sink("DICOM_INFO.txt")
cat("BIRC_ID LUNA_ID SCAN_DATE \nDICOM_INFO")
for(i in 1:length(DICOM_INFO)){
  cat("\n\n", bircID[i], lunaID[i], scanDate[i], "\n")
  print(DICOM_INFO[[i]])
}
sink()

