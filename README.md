# E-commerce Conversion Optimization — Offline A/B Experiment

## Project Overview
This project demonstrates how a Product Data Scientist designs and evaluates an **offline counterfactual A/B experiment** to support e-commerce conversion optimization decisions when online experimentation is not yet available.

The focus is on funnel analysis, user segmentation, rigorous experiment design, and ROI-driven rollout decisions.

---

## Problem Statement
An e-commerce platform observes healthy traffic volume but suboptimal conversion from **cart to purchase**, especially among new users.

The goal of this project is to:
- Identify the primary conversion bottleneck
- Design a statistically sound experiment to evaluate a proposed product improvement
- Quantify business impact and inform rollout decisions

---

## Data Description
This project uses simulated event-level e-commerce data with the following characteristics:
- User-level interaction events (view, cart, purchase)
- Timestamps for funnel ordering
- Attributes enabling user segmentation (e.g., new vs returning users)

The dataset structure mimics a typical analytics warehouse schema.

---

## Methodology Overview
The analysis follows a structured workflow:

1. Funnel construction and conversion drop-off diagnosis  
2. User segmentation to locate responsibility segments  
3. Offline A/B experiment design using salted hash randomization  
4. Statistical validation (A/A test, SRM check, confidence intervals)  
5. Exposure-aware uplift simulation  
6. ROI estimation and rollout recommendation  

All experiments are conducted **offline** and explicitly framed as simulations.

---

## Project Structure
```
├── docs/
│ ├── queries/
│ ├── methodology.md
│ ├── figures/
│ └── interview.md
├── notebooks/
│ ├── 01_data_prep.ipynb
│ ├── 02_funnel_analysis.ipynb
│ ├── 03_segmentation.ipynb
│ ├── 04_experiment_design.ipynb
│ ├── 05_ab_results.ipynb
│ └── 06_roi_and_rollout.ipynb
├── data/
│ └── clean_events.csv
└── README.md
```
---

## Key Takeaways
This project emphasizes:
- Correct experimental thinking over surface-level metrics
- Clear separation between data analysis and decision-making
- Business realism in experiment design and evaluation

---

## Disclaimer
All results in this project are based on **offline simulations** and should be interpreted as decision-support analysis rather than production experiment outcomes.

