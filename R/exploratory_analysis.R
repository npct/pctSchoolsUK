source("setup.R")

# read in the data
if(!exists("sld11"))
  source("R/preprocess-data.R")
  #source("R/analysis-sld.R")

# s11 contains the 2011 flows (origin-destination)
# sld11 contains the information on the schools (destinations) for 2011
# sld is the subset of sld11 we took, selecting only Secondary schools in England with at least 100 pupils

# We ignored the 2015 data (sld15) as no corresponding flows (s15) exist for it

# read in the raw data
# private_dir = "private_data"
# old = setwd(private_dir) 
# #list.files() # what's there
# sld11 = readr::read_tsv(file = "SLD_CENSUS_2011.txt")
# s11 = readr::read_tsv(file = "Spring_Census_2011.txt")
# setwd(old) # go back to working directory
# 
# # fix column names and variable types
# names(sld11) = gsub("^LEA11_","", names(sld11))
# sld11$Northing = as.integer(sld11$Northing)
# 
nrow(sld11)
ncol(sld11)
Mode = function(x) {
  ux = unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
Mode(sld11$Form7_School_Type_Desc)

mean(sld11$Headcount_Pupils)
# 
# # extract the Primary schools
# # vname_primary_f = paste0("FT_Girls_", 1:11)
# # vname_primary_m = paste0("FT_Boys_", 1:11)
# # vname_primary = c(vname_primary_f, vname_primary_m)
# # sld11$Headcount_Primary_male = rowSums(sld11[,vname_primary_m])
# # sld11$Headcount_Primary_female = rowSums(sld11[,vname_primary_f])
# # sld11$Headcount_Primary = rowSums(sld11[,vname_primary])
# # 
# # # extract the Secondary schools
# # vname_secondary_f = paste0("FT_Girls_", 12:18)
# # vname_secondary_m = paste0("FT_Boys_", 12:18)
# # vname_secondary = c(vname_secondary_f, vname_secondary_m)
# # sld11$Headcount_Secondary_male = rowSums(sld11[,vname_secondary_m])
# # sld11$Headcount_Secondary_female = rowSums(sld11[,vname_secondary_f])
# # sld11$Headcount_Secondary = rowSums(sld11[,vname_secondary])
# 
# # Load Phase of Education data so we can select Secondary schools only
# # https://www.whatdotheyknow.com/request/list_of_all_schools_in_england_w
# phase_edu = readxl::read_excel("phase_of_education.xls")
names(phase_edu)
names(sld11)

# The schools that are neither Primary or Secondary have a "Not applicable" phase of education
nrow(sld11)
nrow(sld11) - (nrow(sldpri) + nrow(sldsec))

unique(dplyr::anti_join(sld11, rbind(sldpri,sldsec), by="URN")$Phase)


# 
# before = nrow(sld11)
# sld11 = dplyr::inner_join(sld11, phase_edu, by = c("URN" = "URN"))
# nrow(sld11)
# # 5% of schools lost because we have no phase of education info for them
# before/nrow(sld11)
# 
# unique(sld11$Phase)
# 
# ### Work out the number of Primary and Secondary schools, and the number of students in them
# nrow(sld11)
# #sldpri = sld11[(sld11$Phase == "Primary") | (sld11$Phase == "Middle Deemed Primary") | (sld11$Headcount_Primary > 0), ]
# sldpri = sld11[(sld11$Phase == "Primary") | (sld11$Phase == "Middle Deemed Primary"), ]
# nrow(sldpri)
# 
#sum(sldpri$Headcount_Primary)
sum(sldpri$Headcount_Pupils)
#sum(sldpri$Headcount_Primary)/sum(sld11$Headcount_Pupils)
sum(sldpri$Headcount_Pupils)/sum(sld11$Headcount_Pupils)
# 
# #nrow(sld11)
# #sldsec = sld11[(sld11$Phase == "Secondary") | (sld11$Phase == "Middle Deemed Secondary") | (sld11$Headcount_Secondary > 0), ]
# sldsec = sld11[(sld11$Phase == "Secondary") | (sld11$Phase == "Middle Deemed Secondary"), ]
nrow(sldsec)
ncol(sldsec)
Mode(sldsec$Form7_School_Type_Desc)
mean(sldsec$Headcount_Pupils)

#sum(sldsec$Headcount_Secondary)
sum(sldsec$Headcount_Pupils)
#sum(sldsec$Headcount_Secondary)/sum(sld11$Headcount_Pupils)
sum(sldsec$Headcount_Pupils)/sum(sld11$Headcount_Pupils)

### For Primary and Secondary schools work out gender ratios, and Full-Time vs Part-Time numbers
names(sld11)
#unique(sld11$Estab)
unique(sld11$Gender_Desc)
unique(sld11$Form7_School_Type_Desc)
unique(sld11$Denomination)
unique(sld11$School_Type)
unique(sld11$Admissions_Policy)

# Gender split
sum(sld11$Headcount_Pupils)
sum(sld11$Headcount_Boys)
sum(sld11$Headcount_Girls)
isTRUE((sum(sld11$Headcount_Boys) + sum(sld11$Headcount_Girls)) == sum(sld11$Headcount_Pupils))
sum(sld11$Headcount_Boys)/sum(sld11$Headcount_Pupils)
sum(sld11$Headcount_Girls)/sum(sld11$Headcount_Pupils)

sum(sldpri$Headcount_Boys)/sum(sldpri$Headcount_Pupils)
sum(sldpri$Headcount_Girls)/sum(sldpri$Headcount_Pupils)

sum(sldsec$Headcount_Boys)/sum(sldsec$Headcount_Pupils)
sum(sldsec$Headcount_Girls)/sum(sldsec$Headcount_Pupils)

gendbins = sld11[, c("Headcount_Boys", "Headcount_Girls")]
gendbins$Headcount_Boys = sum(gendbins$Headcount_Boys)
gendbins$Headcount_Girls = sum(gendbins$Headcount_Girls)
names(gendbins) = c("Boys", "Girls")
gendbins = gendbins[1,]
barplot(as.matrix(gendbins))


#par_orig = par()
#par()[["mar"]]
#par(mar=c(7.1,4.1,4.1,2.1))

# Language
sum(sld11$Pupils_Language_English)
sum(sld11$Pupils_Language_Not_English)
sum(sld11$Pupils_Language_Unc)

langbins = sld11[, c("Pupils_Language_English", "Pupils_Language_Not_English", "Pupils_Language_Unc")]
langbins$Pupils_Language_English = sum(langbins$Pupils_Language_English)
langbins$Pupils_Language_Not_English = sum(langbins$Pupils_Language_Not_English)
langbins$Pupils_Language_Unc = sum(langbins$Pupils_Language_Unc)
names(langbins) = c("English", "Not English", "NA")
langbins = langbins[1,]
barplot(as.matrix(langbins), main="Language")



#langbins = cbind(sld11$Pupils_Language_English, sld11$Pupils_Language_Not_English, sld11$Pupils_Language_Unc)
#names(langbins) = c("Eng", "Not Eng","N")
#barplot(langbins)

# Region
#barplot(table(sld11$GORName), las=2)

library(ggplot2)
#ggplot(sld, aes(x=GORName)) + geom_bar() + theme(axis.text.x = element_text(angle=-90, vjust=0.5, hjust=0), axis.title.x = element_text("Region"))
ggplot(sld11, aes(x=Headcount_Pupils)) + geom_histogram(binwidth = 100) #+ stat_function(fun = dnorm)

# Fit Poisson distribution
#ggplot(sld11, aes(x=Headcount_Pupils)) + geom_point(aes(y=dpois(sld11$Headcount_Pupils, mean(sld11$Headcount_Pupils))), colour="red")

# Fit Gaussian distribution
#normalfit = sapply(sld11$Headcount_Pupils, dnorm, mean=mean(sld11$Headcount_Pupils), sd=sd(sld11$Headcount_Pupils))
#ggplot(sld11, aes(x=Headcount_Pupils)) + stat_bin(aes(y=..density..)) + geom_line(aes(x=Headcount_Pupils, y=normalfit), colour="red")

# Get breakdown by Ethnicity
sum(sld11$Pupil_Ethnicty_Unc)

# Full-Time vs Part-Time split
sum(sld11$Headcount_FT_Pupils)
sum(sld11$Headcount_PT_Pupils)

# Religious split
table(sld11$Denomination)
nrow(sld11[sld11$Denomination != "Does not apply", ]) # Religious schools
nrow(sld11[sld11$Denomination == "Does not apply", ]) # Secular schools

#str(sld11, list.len=ncol(sld11))

# Convert categorical columns into factors
for(i in names(sld11)){
  if(is.character(sld11[[i]]) & length(levels(as.factor(sld11[[i]])))<50){
    sld11[[i]] = as.factor(sld11[[i]])
  }
}

str(sld11, list.len=ncol(sld11))

# Get summary statistics for all the columns
for(i in names(sld11)){
  if(!(grepl("FT_",i) | grepl("PT_",i) | grepl("Num_",i) | grepl("Pct_",i))){
    print(paste0("Column:   ",i))
    print(summary(sld11[[i]]))
    cat("\n")
  }
}

library(dplyr)
names(s11)
res_active = group_by(s11, SCHOOLNAME_SPR11) %>%
  summarise(
    Cycle = 100*sum(CYCLE)/sum(TOTAL),
    Walk = 100*sum(WALK)/sum(TOTAL)
    ) %>% 
  arrange(desc(Cycle, Walk))



# LSOA to Local Authority Lookup table
#  http://geoportal.statistics.gov.uk/datasets/6d3b1fc88b284a9bb9d4827530b16da4_0.csv
#lsoa2la = readr::read_csv(RCurl::getURL("http://geoportal.statistics.gov.uk/datasets/6d3b1fc88b284a9bb9d4827530b16da4_0.csv"))
# readr::write_csv(lsoa2la, "private_data/LSOA2LAD_lookup.csv") 
lsoa2la = readr::read_csv("private_data/LSOA2LAD_lookup.csv")

# /home/geoif/pct/pctSchoolsUK/private_data/Local_Authority_BoundaryData
# https://census.edina.ac.uk/bds.html
# lads = shapefile("private_data/england_lad_2011.shp")
# lads = rmapshaper::ms_simplify(lads) # simplify the lads (will run faster in future)
# saveRDS(lads, "../pct-bigdata/england_lad_2011.Rds")
lads = readRDS("../pct-bigdata/england_lad_2011.Rds")
lads = spTransform(lads, CRS("+init=epsg:4326"))

s11la = dplyr::left_join(s11, lsoa2la, by=c("LLSOA_SPR11"="LSOA11CD"))
# nrow(dplyr::inner_join(s11la, as.data.frame(lads), by=c("LAD11CD"="code")))
s11la = dplyr::left_join(s11la, as.data.frame(lads), by=c("LAD11CD"="code")) # Join to get Local Authority names

res_active_la_name = group_by(s11la[!is.na(s11la$name),], name) %>%
  summarise(
    Cycle = 100*sum(CYCLE)/sum(TOTAL),
    Walk = 100*sum(WALK)/sum(TOTAL)
  ) %>% 
  arrange(desc(Cycle, Walk))

res_active_la_name

#res_active_la_name_bottom = res_active_la_name %>% arrange(Cycle,Walk) %>% head(n=10)

lad_pcycle = geojsonio::geojson_read("../pct-bigdata/las-pcycle.geojson", what="sp")

res_active_la = group_by(s11la[!is.na(s11la$name),], LAD11CD) %>%
  summarise(
    Cycle = 100*sum(CYCLE)/sum(TOTAL),
    Walk = 100*sum(WALK)/sum(TOTAL)
  ) %>% 
  arrange(desc(Cycle, Walk))


lads_active = sp::merge(lads, res_active_la, by.x="label", by.y="LAD11CD")
#lads_active = sp::merge(lad_pcycle, res_active_la, by.x="CODE", by.y="LAD11CD")

#par(mfrow = c(1, 2))
#spplot(lads_active, zcol="Cycle")
#spplot(lads_active, zcol="Walk")

library(tmap)
# These plots commented to avoid long compilation times when running knitr to create paper
#qtm(lads_active, fill = c("Walk", "Cycle"), free.scales.fill=FALSE)
#qtm(lads_active, fill = c("Walk", "Cycle"))

#pairs(~Cycle+Walk, data=res_active)
plot(res_active$Cycle, res_active$Walk, xlab="Cycling commutes to school (%)", ylab="Walking commutes to school (%)")

lad_pcycle$CODE = as.character(lad_pcycle$CODE)
schoolvswork = inner_join(res_active_la, as.data.frame(lad_pcycle), by=c("LAD11CD"="CODE"))

#pairs(~Cycle+pcycle, data=schoolvswork)
plot(schoolvswork$Cycle, schoolvswork$pcycle, xlab="Cycling commutes to school (%)", ylab="Cycling commutes to work (%)")
 #cor(schoolvswork[, c("pcycle","Cycle")], use="complete")
cor(schoolvswork$pcycle, schoolvswork$Cycle, use="complete")
cor.test(schoolvswork$Cycle, schoolvswork$pcycle, alternative="two.sided", method="pearson")


barplot(table(sld11$GORName), las=2)
barplot(table(sld11$Denomination), las=2)
barplot(table(sld11$Phase), las=2)
barplot(table(sld11$`TypeOfEstablishment (name)`), las=2)
barplot(table(sld11$Gender_Desc), las=2)
barplot(table(sld11$Form7_School_Type_Desc), las=2)
barplot(table(sld11$School_Type), las=2)
barplot(table(sld11$Admissions_Policy), las=2)




# FLOWS DATA

nrow(s11)
ncol(s11)
s = s11[!is.na(s11$LLSOA_SPR11),] # drop flows with no LSOA data
nrow(s)

mean(s11$TOTAL)
s = s[s$URN_SPR11 %in% sldsec$URN,]
nrow(s)
ncol(s)

mean(s$TOTAL)

summary(sldsec$URN %in% s11$URN_SPR11)

#par(par_orig)




# #devtools::install_github("cttobin/ggthemr")
# library("ggthemr")
# 
# # https://github.com/cttobin/ggthemr#palettes
# #ggthemr(palette = "dust", layout = "clear")
# #ggthemr(palette = "fresh", layout = "clear")
# ggthemr(palette = "pale", layout = "clear")
# 
# ggplot(as.data.frame(sld11$GORName), aes(x = factor(sld11$GORName))) + 
#   geom_bar(stat = "count") + 
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))
# 
# ggthemr_reset()

