# Cricket Data Analysis

A Power BI dashboard built using web-scraped cricket data to analyze batting, bowling, and fielding performance with interactive slicers, DAX-based metrics, and strike-rate categorization.

---

## 📌 Project Overview

This project is a Power BI dashboard created using cricket data sourced from ESPN through web scraping.  
The dashboard provides an interactive analysis of **player performance across batting, bowling, and fielding**, enabling users to explore detailed statistics for individual players.

The project demonstrates skills in **data extraction, data cleaning, DAX, and dashboard design**.

---

## 🎯 Business Objective
To analyze and compare cricket players’ performance metrics using real-world data, allowing users to:
- Evaluate batting efficiency
- Assess bowling effectiveness
- Understand fielding contributions
- Categorize players based on strike rate performance

---

## 📂 Data Source
- **Source:** ESPN (Web)
- **Method:** Web scraping using Power BI Web Connector
- **Data Type:** Player-level cricket statistics

---

## 🧹 Data Preparation & Cleaning
- Scraped raw cricket data from ESPN web pages
- Cleaned and transformed data using Power Query
- Handled missing values and formatted numerical fields
- Created calculated columns and measures using DAX

---

## 📊 Dashboard Pages

### 1️⃣ Batting Data Analysis
- Key batting metrics displayed using KPI cards
- Strike rate, runs, averages, and boundaries analysis
- Player-wise comparison

### 2️⃣ Bowling Data Analysis
- Bowling performance metrics such as:
  - Wickets
  - Economy rate
  - Bowling averages
- Player-based analysis

### 3️⃣ Fielding Data Analysis
- Fielding contribution metrics
- Catches and overall fielding impact

---

## 🎛️ Interactive Features
- **Player Name Slicer** for dynamic filtering across all pages
- Multiple KPI cards that update based on player selection
- Clean and intuitive layout for easy analysis

---

## 📐 DAX & Calculations
- Created calculated columns and measures using DAX
- Added a **Strike Rate Category** column to classify players:
  - Very Low
  - Low
  - Moderate
  - High

---

## 🛠️ Tools & Technologies
- Power BI
- Power Query
- DAX
- Web Data Scraping
- Data Cleaning & Transformation

---

## 📁 Repository Structure

ESPN_Cricket_Data_Analysis/
│
├── Images/
├── CricketersDataAnalysis.pbix # Power BI report file
├── README.md
