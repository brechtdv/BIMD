### BIMD // HOUSING DEPRIVATION
### 10/01/2022

## required packages
library(BelgiumMaps.StatBel)
library(sp)

## import data
hdi_2011 <-
read.csv(paste0("https://raw.githubusercontent.com/brechtdv/",
                "BIMD/main/housing/housing_index_2011.csv"))
hdi_2011$DECILE <- factor(hdi_2011$DECILE, levels = 10:1)

## shapefile
data(BE_ADMIN_SECTORS)

## merge datasets
names(hdi_2011)[names(hdi_2011) == "CD_RES_SECTOR"] <- "CD_REFNIS_SECTOR"
BE_ADMIN_SECTORS@data <-
  merge(BE_ADMIN_SECTORS@data, hdi_2011, all = TRUE)
sum(is.na(BE_ADMIN_SECTORS@data$DECILE))
sum(is.na(BE_ADMIN_SECTORS@data$DECILE)) / nrow(BE_ADMIN_SECTORS)
sum(hdi_2011$CD_REFNIS_SECTOR %in% BE_ADMIN_SECTORS@data$CD_REFNIS_SECTOR)

## plot results
labs <- c("10 (Least deprived)", 9:2, "1 (Most deprived)")

png("hdi-2011-deciles.png", 10, 10, units = "in", res = 300)
sp::spplot(
  BE_ADMIN_SECTORS, "DECILE",
  main = "Housing Deprivation by Statistical Sector, Belgium, 2011",
  col = NA,
  col.regions = rev(bpy.colors(10)),
  colorkey = list(tick.number = 10, labels = list(labels = labs)))
dev.off()
