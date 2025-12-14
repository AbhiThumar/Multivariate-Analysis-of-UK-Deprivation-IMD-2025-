#------QUESTION 1--------

library(tidyverse)
library(GGally)
library(readr)
library(olsrr)

#Load datasets
imd_data= read_csv("imd2025_group.csv")
lad_to_county = read_csv("Local_Authority_District_to_County_(December_2024)_Lookup_in_EN.csv")
lad_to_region = read_csv("Local_Authority_District_to_Region_(December_2024)_Lookup_in_EN.csv")


#create county to region lookup 
county_region_lookup = lad_to_county %>%
  left_join(lad_to_region %>% select(LAD24CD, RGN24CD, RGN24NM),
    by = "LAD24CD") %>%
  distinct(CTY24CD, .keep_all = TRUE) %>%
  select(CTY24CD, CTY24NM, RGN24NM)

county_region_lookup
  
#join LAD to region, join counties, final region=lad region
  imd_with_region = imd_data %>%
  left_join(lad_to_region %>% select(LAD24CD, RGN24NM),
            by="LAD24CD") %>%
  rename(Region_LAD = RGN24NM) %>%
  left_join(county_region_lookup %>% rename(LAD24CD = CTY24CD, Region_County = RGN24NM),
            by="LAD24CD") %>%
  mutate(Region = coalesce(Region, Region_LAD, Region_County)) %>%
  select(-Region_LAD, -Region_County)

  imd_with_region

#summary table
district_count_by_region = imd_with_region%>%
  group_by(Region) %>%
  summarise(number_of_districts = n()) %>%
  arrange(desc(number_of_districts))

district_count_by_region


# scatter matrix of the seven IMD domains
domains = imd_with_region %>%
  select(Income, Employment, Education, Health, Crime, Barriers, Living)
ggpairs(domains, color="Region")












#-----QUESTION 2------------

region_lookup <- tibble(
  Region = c("North East","North West","Yorkshire and The Humber","South East","South West","London","East of England"),

  area_group = c("North","North","North","South","South","South","South")
)

north_south_data = imd_with_region %>%
  inner_join(region_lookup, by = "Region")
north_south_data

a <- north_south_data%>% select(-LAD24CD,-LAD24NM,-Rank,-CTY24NM,-area_group,-Region)
full_model <- lm(Overall ~ ., data = a)
best <- ols_step_best_subset(full_model)
best


aic1 <- lm(Overall ~ Income+Employment, data = north_south_data)
summary(aic1)
AIC(aic1)


aic2 <- lm(Overall ~ Employment+Health, data = north_south_data)
summary(aic2)
AIC(aic2)



#scatter matrix
ggpairs(north_south_data,
        columns = c("Income","Employment","Education","Health","Crime","Barriers","Living"),
        aes(color = area_group))


ggplot(north_south_data, aes(Income, Employment, color = area_group)) + geom_point(size=3) + theme_minimal()


ggplot(north_south_data, aes(Income, Employment, color = Region)) + geom_point(size=3) + theme_minimal()

library(GGally)

ggpairs(
  north_south_data,
  columns = c("Employment", "Income"),
  aes(colour = Region))

#ggplot(north_south_data, aes(Employment, Income, colour = Region)) + geom_point(size=3) + theme_minimal()

#autoplot(aic1, label = TRUE, label.size = 2)


#---------QUESTION 3- -----
#--------------a--------------
library(tidyverse)
library(GGally)        
library(ggfortify)     
library(ggplot2)
imd = read_csv('imd2025_individual.csv')

imd_domains = imd %>% select(Income, Employment, Education, Health, Crime, Barriers, Living)

pca_results = prcomp(imd_domains, scale. = TRUE)
pca_results


# PCA scree plot 
variance= (pca_results$sdev)^2
variance_explained = variance / sum(variance)  
ggplot(NULL, aes(x = 1:7, y = 100 * variance_explained)) +
  geom_col() +
  xlab("Principal component") + ylab("Percentage variance explained") +
  ggtitle("Scree plot: PCA on 7 IMD domains")

# ---- Loadings plots for PC1, PC2, PC3 ----
loadings = as.data.frame(pca_results$rotation[,1:3])
loadings$Symbol = row.names(loadings)
loadings= gather(loadings, key='Component', value='Weight', -Symbol)

ggplot(loadings, aes(x = Symbol, y = Weight)) +
  geom_bar(stat='identity') +
  facet_grid(Component ~ .) +
  xlab("") + ggtitle("PCA loadings: PC1, PC2, PC3")

#PC1 vs PC2 biplot
autoplot(pca_results,
         data = imd,
         colour = "Region",
         loadings = TRUE,
         loadings.label = TRUE,
         loadings.label.size = 3) +
  ggtitle("PCA Biplot: PC1 vs PC2")


#PC2 vs PC3 biplot
autoplot(pca_results,
         data = imd,
         x = 2, y = 3,
         colour = "Region",
         loadings = TRUE,
         loadings.label = TRUE,
         loadings.label.size = 3) +
  ggtitle("PCA Biplot: PC2 vs PC3")





#---------------------b-------------------------
#London only with seven IMD domains
imd_london = imd %>% filter(Region == "London")

imd_lon_domains = imd_london %>%
  select(Income, Employment, Education, Health, Crime, Barriers, Living)

# PCA for London only
pca_london = prcomp(imd_lon_domains, scale. = TRUE)

# Scree plot
lon_var = (pca_london$sdev)^2
lon_var_explained = lon_var / sum(lon_var)
ggplot(NULL, aes(x = 1:7, y = lon_var_explained *100)) +
  geom_col() +
  xlab("Principal component") +
  ylab("Percentage variance explained") +
  ggtitle("Scree plot: London Only")



# Loadings
pca_london$rotation[,1:3]

loadings = as.data.frame(pca_london$rotation[,1:3])
loadings$Symbol = row.names(loadings)
loadings= gather(loadings, key='Component', value='Weight', -Symbol)

ggplot(loadings, aes(x = Symbol, y = Weight)) +
  geom_bar(stat='identity') +
  facet_grid(Component ~ .) +
  xlab("") + ggtitle("PCA loadings: PC1, PC2, PC3")

# Biplot PC1 vs PC2
autoplot(pca_london,
         data = imd_london,
         loadings = TRUE,
         loadings.label = TRUE,
         loadings.label.size = 3) +
  ggtitle("London Only: PC1 vs PC2")

#PC2 vs PC3 biplot
autoplot(pca_london,
         data = imd_london,
         x = 2, y = 3,
         loadings = TRUE,
         loadings.label = TRUE,
         loadings.label.size = 3) +
  ggtitle("PCA Biplot: PC2 vs PC3")







#----------QUESTION 4----------------
#--------------a-------------

library(tidyverse)
imd= read_csv("imd2025_group.csv")


imd_domains = imd %>%
  select(Income, Employment, Education, Health, Crime, Barriers, Living)


library(cluster)
#agglomerative clustering 

#EUCLIDEAN AND SINGLE
Eucl = dist(scale(imd_domains), method='euclidean')
cluster_results= agnes ( Eucl, method='single')
cluster_results
ac_e_single = cluster_results$ac
#AC = 0.83 


#EUCLIDEAN AND WARD
Eucl = dist(scale(imd_domains), method='euclidean')
cluster_results= agnes ( Eucl, method='ward')
cluster_results
ac_e_ward = cluster_results$ac 
#AC = 0.96


#MANHATTAN AND WARD
Manh = dist(scale(imd_domains), method='manhattan')
cluster_results= agnes ( Manh, method='ward')
cluster_results
ac_m_ward = cluster_results$ac 
#AC = 0.97


#MANHATTAN AND SINGLE
Manh = dist(scale(imd_domains), method='manhattan')
cluster_results= agnes ( Manh, method='single')
ac_m_single = cluster_results$ac 
cluster_results
#AC = 0.80


#dendogram
#MANHATTAN AND WARD
Manh = dist(scale(imd_domains), method='manhattan')
cluster_results= agnes ( Manh, method='ward')
cluster_results
plot(cluster_results,which.plots=2)
#AC = 0.97


#comparison table
comparison_table = data.frame(
  Distance = c("Euclidean", "Euclidean", "Manhattan", "Manhattan"),
  Method   = c("Single", "Ward", "Single", "Ward"),
  Agglomerative_Coefficient = c(ac_e_single, ac_e_ward, ac_m_single, ac_m_ward))

comparison_table






#-------------------b-------------------

# Transpose to cluster IMD domains
imd_domains = imd %>%
  select(Income, Employment, Education, Health, Crime, Barriers, Living)
domains_t = t(scale(imd_domains))


#EUCLIDEAN AND SINGLE
Eucl = dist((domains_t), method='euclidean')
cluster_results= agnes ( Eucl, method='single')
cluster_results
ac_e_single = cluster_results$ac
#AC = 0.43

#MANHATTAN AND WARD
Manh = dist((domains_t), method='manhattan')
cluster_results= agnes ( Manh, method='ward')
cluster_results
ac_m_ward = cluster_results$ac 
#AC = 0.63


#MANHATTAN AND SINGLE
Manh = dist((domains_t), method='manhattan')
cluster_results= agnes ( Manh, method='single')
ac_m_single = cluster_results$ac 
cluster_results
#AC = 0.47

#EUCLIDEAN AND WARD
Eucl = dist((domains_t), method='euclidean')
cluster_results= agnes ( Eucl, method='ward')
cluster_results
ac_e_ward = cluster_results$ac 
#AC = 0.64


#dendogram

#EUCLIDEAN AND WARD
Eucl = dist((domains_t), method='euclidean')
cluster_results= agnes ( Eucl, method='ward')
cluster_results
ac_e_ward = cluster_results$ac 
plot(cluster_results,which.plots=2)
#AC=0.64

#comparison table
comparison_table = data.frame(
  Distance = c("Euclidean", "Euclidean", "Manhattan", "Manhattan"),
  Method   = c("Single", "Ward", "Single", "Ward"),
  Agglomerative_Coefficient = c(ac_e_single, ac_e_ward, ac_m_single, ac_m_ward))

comparison_table













p
#-------------QUESTION 5---------------------

library (ggplot2)
library (sf)
library (tidyverse)

districts_map = st_read("LAD_DEC_24_UK_BFC.shp")


#checking
#names(districts_map)
#names(imd)

pca_results = prcomp(imd %>% select(Income, Employment, Education, Health, Crime, Barriers, Living), scale. = TRUE)

imd = imd %>%
  mutate(
    PC1 = pca_results$x[, 1],
    PC2 = pca_results$x[, 2])

map_data =districts_map %>%
  left_join(imd, by = "LAD24CD")

ggplot(map_data) +
  geom_sf(aes(fill = Overall), colour = NA) +
  ggtitle("Overall IMD score by district") +
  theme_void()


ggplot(map_data) +
  geom_sf(aes(fill = PC1), colour = NA) +
  ggtitle("PC1 (general deprivation) by district") +
  theme_void()


ggplot(map_data) +
  geom_sf(aes(fill = PC2), colour = NA) +
  ggtitle("PC2 (Barriers / Living environment) by district") +
  theme_void()







   