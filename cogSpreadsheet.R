library(gdata) # for reading excel files

dirProcess <- commandArgs()[length(commandArgs())] # script run via command line, with dirProcess as argument
#dirProcess <- "/home/simmondsdj/COG"

# load spreadsheets for anti and mgs
# only keep columns for id, date, birc_id and run information (4 for anti, 3 for mgs)
anti <- read.xls(file.path(dirProcess, "Anti-State&MGSEncode_data.xls"), sheet=2, stringsAsFactors=FALSE) # anti
anti <- anti[,c(4:6,10:13)]
mgs <- read.xls(file.path(dirProcess, "Anti-State&MGSEncode_data.xls"), sheet=3, stringsAsFactors=FALSE)
mgs <- mgs[,c(4:6,10:12)]

# anti columns have both the scan number in the series as well as the script used - separating into columns
  # i used this command to identify those who don't have the "number(script)" format, and fix the spreadsheet for errors manually
  # for(j in 1:4) anti[!grepl("(", anti[,j], fixed=T),]
for(j in 4:7){
  # remove whitespace (because some have it, some don't), also closing parenthesis (will use opening parenthesis as delimiter)
  anti[,j] <- gsub(" ", "", anti[,j])
  anti[,j] <- gsub(")", "", anti[,j])
  # split into scan number and script
  tempSplit <- t(sapply(1:length(anti[,j]), function(i){
    temp <- strsplit(anti[i,j], "(", fixed=TRUE)[[1]]
    if(length(temp) < 2) temp <- c("","") # if no scan, put in 2 empty strings
    if(length(temp) > 2) temp <- temp[1:2] # TEMPFIX: encountered error in spreadsheet with extra parenthesis, can take this line 
out once fixed
    if(nchar(temp[2])==3) temp[2] <- paste(0, temp[2], sep="") # for script, some put a 0 before single digits, some don't (ex, 
"3AV" vs. "03AV"), changing so all have leading zero
    temp
  }))
  anti[,j] <- tempSplit[,1]
  anti[,j+4] <- tempSplit[,2]
}
names(anti)[8:11] <- paste(names(anti)[4:7], "script", sep="_")

# merge anti and MGS spreadsheets, fix formatting issues
merged <- merge(anti, mgs, all=TRUE, by=c("BIRC_ID", "Oxford_ID", "Scan_Date"))
merged$Scan_Date <- gsub("-", "", merged$Scan_Date)
merged$BIRC_ID <- ifelse(nchar(merged$BIRC_ID)==11, paste(0, merged$BIRC_ID, sep=""), merged$BIRC_ID)

# write tables, including the whole merged table and then separately for variables for easy processing
write.table(merged, file=file.path(dirProcess, "cogSpreadsheet"), row.names=F, quote=F)
write.table(merged$BIRC_ID, file=file.path(dirProcess, "BIRC_ID"), row.names=F, col.names=F, quote=F)
write.table(merged$Oxford_ID, file=file.path(dirProcess, "Oxford_ID"), row.names=F, col.names=F, quote=F)
write.table(merged$Scan_Date, file=file.path(dirProcess, "Scan_Date"), row.names=F, col.names=F, quote=F)
write.table(as.numeric(merged$Anti.State_1), file=file.path(dirProcess, "Anti.State_1"), row.names=F, col.names=F, quote=F)
write.table(as.numeric(merged$Anti.State_2), file=file.path(dirProcess, "Anti.State_2"), row.names=F, col.names=F, quote=F)
write.table(as.numeric(merged$Anti.State_3), file=file.path(dirProcess, "Anti.State_3"), row.names=F, col.names=F, quote=F)
write.table(as.numeric(merged$Anti.State_4), file=file.path(dirProcess, "Anti.State_4"), row.names=F, col.names=F, quote=F)
write.table(as.numeric(merged$Mgs.Encode_1), file=file.path(dirProcess, "Mgs.Encode_1"), row.names=F, col.names=F, quote=F)
write.table(as.numeric(merged$Mgs.Encode_2), file=file.path(dirProcess, "Mgs.Encode_2"), row.names=F, col.names=F, quote=F)
write.table(as.numeric(merged$Mgs.Encode_3), file=file.path(dirProcess, "Mgs.Encode_3"), row.names=F, col.names=F, quote=F)


