library(tidyverse)
library(dplyr)
library(olsrr)
library(ggfortify)

# (2)
df <- read.csv("imd2025_individual.csv")
#Model 1
model1 <- lm(Overall ~ Employment + Living, data = df)
summary(model1)
AIC(model1)
# The best two-predictor linear mode is Income and Employment as per olsrr


#Model 2
df1 <- df%>% select(-Rank,-LAD24CD,-LAD24NM)
full_model <- lm(Overall ~ ., data = df1)
best <- ols_step_best_subset(full_model)
best

model2 <- lm(Overall ~ Income+Employment+Education+Living, data = df)
summary(model2)
AIC(model2)

# The best overall that uses at most four quantitative predictors (excluding Rank) is
# Income Employment Education Living 


df_london <- df1%>% filter(Region == "London") %>% select(-Region)
london_model <- lm(Overall ~ ., data = df_london)
best2 <- ols_step_best_subset(london_model, include = "Crime")
best2
# Best four quantitative predictors in region London including "Crime" is 
# Income Education Crime Living


df_non_london <- df1%>% filter(Region != "London") %>% select(-Region)
non_london_model <- lm(Overall ~ ., data = df_non_london)
best3 <- ols_step_best_subset(non_london_model, include = "Crime")
best3

# Best four quantitative predictors excluding region London including "Crime" is 
# Income Employment Crime Living 


model3_london <- lm(Overall ~ Income+Education+Crime+Living, data = df)
summary(model3_london)
AIC(model3_london)

model3_non_london <- lm(Overall ~ Income+Employment+Crime+Living, data = df)
summary(model3_non_london)
AIC(model3_non_london)

# (3)

autoplot(model3_london, label = TRUE, label.size = 2)
autoplot(model3_non_london, label = TRUE, label.size = 2)