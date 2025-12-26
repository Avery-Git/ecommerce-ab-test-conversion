# E-commerce Conversion Optimization — Offline A/B Experiment (Counterfactual)

## Project Overview
This project demonstrates how a Product Data Scientist designs and evaluates an **offline counterfactual A/B experiment** to support e-commerce conversion optimization decisions when online experimentation is not yet available.

The focus is on funnel diagnosis, user segmentation, rigorous experiment design, exposure-aware causal evaluation, and ROI-driven rollout decisions.

> **Key framing:** We use **one deterministic salt-hash assignment** (one randomized split) and report **two outcomes** under the same assignment:
> 1) **Add-to-Cart** (PDP stage: View → Cart)  
> 2) **Purchase** (Checkout stage: Cart → Purchase)

All results are generated **offline** and are explicitly framed as simulations for decision support.

---

## Problem Statement
An e-commerce platform observes healthy traffic volume but suboptimal funnel performance. Funnel analysis suggests the **primary drop-off occurs at View → Cart**, especially among **new users**. Meanwhile, downstream **Cart → Purchase** friction may also exist and is tracked as a secondary business outcome.

The goals of this project are to:
- Identify the primary conversion bottleneck
- Design a statistically sound offline experiment using reproducible user-level assignment
- Quantify causal impact on key funnel metrics (Add-to-Cart, Purchase)
- Translate impact into ROI and propose a practical rollout plan

---

## Data Description
This project uses simulated e-commerce event data with:
- User-level funnel events: `view`, `cart`, `purchase`
- Timestamps enabling funnel ordering (where applicable)
- User segmentation attributes (e.g., `new` vs `returning`)

The dataset mimics a typical analytics warehouse schema.

---

## Methodology Overview
The analysis follows a structured workflow:

1. Funnel construction and conversion drop-off diagnosis  
2. User segmentation (New vs Returning) to locate responsibility segments  
3. Deterministic user-level assignment using **salted hash randomization** (reproducible and orthogonalizable)  
4. Statistical validation: **SRM check**, **A/A check**, confidence intervals  
5. **Exposure-aware counterfactual simulation** (treatment effects applied only to eligible exposed users)  
6. Causal evaluation and heterogeneity analysis (New vs Returning)  
7. ROI estimation and rollout recommendation with cost sensitivity

> **Important note:** This project reports **multiple outcomes** from the **same randomized assignment**.  
> It does **not** claim two independent experiments.

---

## Experiments & Results (Two Outcomes Under One Assignment)

### Outcome B — PDP Stage (View → Cart): Add-to-Cart
**Interpretation:** This outcome evaluates whether a PDP-style improvement increases users’ likelihood to add items to cart after viewing.

- **Exposure:** `view`  
- **Outcome:** `cart` (Add-to-Cart)  
- **Estimands reported:** ITT (Global), CATE (Exposed only), Placebo (Non-exposed)

#### Causal Impact (Add-to-Cart)
- **ITT (Global, all users):**  
  - p_treat = 0.205765, p_control = 0.198224  
  - **Δ(Add-to-Cart) = +0.007541** (95% CI: +0.006859 ~ +0.008224)  
  - z = 21.65382, p ≈ 5.59e-104
- **CATE (Local, exposed only):**  
  - **Δ(Add-to-Cart) = +0.007541** (95% CI: +0.006859 ~ +0.008224)  
  - z = 21.65382, p ≈ 5.59e-104
- **Placebo (Non-exposed):**  
  - Not computable due to missing variant(s) within the non-exposed subgroup in this dataset slice  
  - (Handled explicitly in code as a non-failing diagnostic)

#### Heterogeneity (Add-to-Cart uplift by segment)
- **New users:** Δ = +0.006939 (95% CI: +0.005006 ~ +0.008872)  
- **Returning users:** Δ = +0.007571 (95% CI: +0.006849 ~ +0.008293)

**Conclusion:** PDP-stage improvements show a statistically and causally robust uplift in Add-to-Cart, with consistent gains across New and Returning users.

---

### Outcome A — Checkout Stage (Cart → Purchase): Purchase
**Interpretation:** This outcome evaluates whether a checkout UI optimization reduces friction and increases purchase conversion among cart users.

- **Exposure:** `cart`  
- **Outcome:** `purchase`  
- **Estimands reported:** ITT (Global), CATE (Exposed only), Placebo (Non-exposed)

#### Causal Impact (Purchase)
- **ITT (Global, all users):**  
  - p_treat = 0.106038, p_control = 0.101374  
  - **Δ(Purchase) = +0.004664** (95% CI: +0.004146 ~ +0.005182)  
  - z = 17.636691, p ≈ 1.29e-69
- **CATE (Local, exposed only):**  
  - p_treat = 0.536324, p_control = 0.511241  
  - **Δ(Purchase) = +0.025083** (95% CI: +0.023175 ~ +0.026990)  
  - z = 25.762870, p ≈ 2.31e-146
- **Placebo (Non-exposed):**  
  - p_treat = 0.000000, p_control = 0.000000  
  - **Δ = 0.000000** (as expected when non-exposed users have zero purchase probability by construction)

#### Heterogeneity (Purchase uplift by segment, exposed only)
- **New users:** Δ = +0.056825 (95% CI: +0.048210 ~ +0.065440)  
- **Returning users:** Δ = +0.023446 (95% CI: +0.021490 ~ +0.025402)

**Conclusion:** Checkout optimization shows a strong and causally robust uplift in purchase conversion, with larger local impact among New users.

---

## ROI & Rollout Decision (Business Translation)
### Assumptions
- Data window: **30 days** (annualized × **12.17**)  
- Population: ~ **5.3M users**  
- AOV assumption: **$80**

### Business impact uses Purchase ITT
To translate causal impact into annual business value, we use **Purchase ITT (Global, all users)**:
- **Δ(Purchase) = +0.004664** (95% CI: +0.004146 ~ +0.005182)

This yields annualized incremental orders and GMV under different rollout scenarios.

> Add-to-Cart results are reported as upstream evidence and mechanism support.  
> ROI is calculated on **orders/GMV (Purchase)** for direct business relevance.

### Rollout Scenarios (Annualized)
| Rollout Scenario | Δ Orders / Year | Δ GMV / Year | 95% GMV CI |
|---|---:|---:|---:|
| All users | +314,407 | +$25.15M | [$22.47M, $27.84M] |
| New users only | +25,989 | +$2.08M | [$1.86M, $2.30M] |

### ROI Sensitivity Analysis
Even under worst-case annual cost assumptions, ROI remains strongly positive:
- All users rollout: ROI ≈ +$24.95M / year  
- New users rollout: ROI ≈ +$1.88M / year  

(See `06_roi_and_rollout.ipynb` for cost cases and computations.)

### Recommended Rollout Plan
- **Stage 1 — 10% Canary**  
  Validate system stability & metric direction  
  Guardrails: latency, error rate, checkout drop-off
- **Stage 2 — 50% Scale-up**  
  Monitor persistence of uplift  
  Check heterogeneity (New vs Returning) and SRM
- **Stage 3 — 100% Rollout**  
  Full deployment  
  Weekly monitoring of CR, GMV, and segment effects
- **Rollback Conditions**  
  Guardrail regression, SRM anomaly, sustained negative ΔCR beyond statistical noise

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
- **One randomized assignment, multiple outcomes:** a practical way to evaluate multiple funnel stages consistently offline  
- **Causal rigor:** SRM/A-A checks + exposure-aware evaluation avoid misleading naive comparisons  
- **Mechanism + business translation:** Add-to-Cart supports diagnosis and mechanism; Purchase supports ROI and rollout decisions  
- **Actionability:** rollout plan includes guardrails, scaling stages, and rollback criteria

---

## Disclaimer
All results in this project are based on **offline simulations** and should be interpreted as decision-support analysis rather than production experiment outcomes.
