# Multivariate Analysis of UK Deprivation (IMD 2025)

## 📌 Project Overview
This project explores patterns of deprivation across English local authority districts using the **Index of Multiple Deprivation (IMD) 2025** dataset.  
The analysis applies a range of **multivariate statistical techniques** to understand relationships between deprivation domains, regional differences, and spatial patterns.

The work was originally completed as part of an MSc Data Science module and has been adapted here as a **portfolio project** demonstrating applied data analysis in **R**.

---

## 🎯 Objectives
- Clean and enrich IMD data with **regional information**
- Explore relationships between IMD domains using **visual and statistical methods**
- Compare **North vs South** deprivation patterns
- Reduce dimensionality using **Principal Component Analysis (PCA)**
- Identify similarity structures using **hierarchical clustering**
- Visualise deprivation patterns using **choropleth maps**

---

## 🗂 Dataset
- **IMD 2025** (district-level data for England)
- Lookup tables for:
  - Local Authority → County
  - Local Authority → Region
- UK Local Authority boundary shapefile (for mapping)

> The IMD dataset includes seven domains:
> - Income  
> - Employment  
> - Education  
> - Health  
> - Crime  
> - Barriers to Housing and Services  
> - Living Environment  

---

## 🔧 Tools & Libraries
**Language:** R  

**Key libraries used:**
- `tidyverse` – data manipulation and visualisation  
- `GGally` – scatterplot matrices  
- `ggplot2` – visualisation  
- `ggfortify` – PCA biplots  
- `cluster` – hierarchical clustering  
- `sf` – spatial data handling  

---

## 📊 Analysis Breakdown

### 1️⃣ Data Integration
- Created a **County → Region lookup table**
- Filled missing regional values in the IMD dataset
- Generated summary tables of districts by region

### 2️⃣ Exploratory Data Analysis
- Scatterplot matrices to examine relationships between IMD domains
- Strong correlations observed between:
  - Income, Employment, Education, Health, and Crime
- Barriers and Living Environment showed weaker correlations

### 3️⃣ North vs South Comparison
- Created a custom **North / South classification**
- Visualised domain differences using scatter plots
- Identified **Income and Employment** as the strongest predictors of North–South separation
- Model selection confirmed using **AIC**

### 4️⃣ Principal Component Analysis (PCA)
- PCA applied to the seven IMD domains
- Key findings:
  - **PC1** (~60% variance): general socio-economic deprivation
  - **PC2** (~20% variance): housing barriers and living environment
  - **PC3**: contrast between Barriers and Living
- Regional clustering observed in PCA space
- Separate PCA performed for **London only**, revealing more balanced domain contributions

### 5️⃣ Cluster Analysis
- Hierarchical clustering using:
  - Euclidean and Manhattan distances
  - Single linkage and Ward’s method
- Evaluated cluster quality using **agglomerative coefficients**
- Best-performing method:
  - **Manhattan distance + Ward’s method**
- Clear clustering found among:
  - Income, Employment, Health, Crime
  - Barriers and Living forming a separate group

### 6️⃣ Spatial Analysis
- Choropleth maps created for:
  - Overall IMD score
  - PC1 (general deprivation)
  - PC2 (housing and environment)
- Findings:
  - Strong **North–South divide** in overall deprivation and PC1
  - PC2 highlights coastal and southern patterns not visible in overall IMD

---

## 🧠 Key Insights
- Deprivation is **multi-dimensional** and cannot be explained by a single factor
- Income and Employment dominate overall deprivation patterns
- Housing and living environment form a **distinct spatial dimension**
- Regional context plays a significant role in deprivation profiles

---

## 📚 Academic Context
This project was completed as part of:
MSc Data Science – Data Analytics module
and is shared here for educational and portfolio purposes.

