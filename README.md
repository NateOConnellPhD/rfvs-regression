
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rfvs-regression

**Note**: The following work titled *A Comparison of Random Forest
Variable Selection Methods for Regression Modeling of Continuous
Outcomes* by O’Connell, N.S., Jaeger, B.C., Bullock, G.S., and Speiser,
J.L. is currently submitted for peer review publication.

<!-- badges: start -->
<!-- badges: end -->

The goal of rfvs-regression is to compare random forest variable
selection techniques for continuous outcomes. We compare several methods
available through various R packages and user defined functions from
published paper appendices. The code for implementing each RF variable
selection approach tested can be found in the function “rfvs()” and each
of the methods assessed and compared are given in the following table:

<br/>

<table class="table" style="color: black; margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Abbreviation in Paper
</th>
<th style="text-align:left;">
Publication
</th>
<th style="text-align:left;">
R package
</th>
<th style="text-align:left;">
Approach
</th>
<th style="text-align:left;">
Type of forest method
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
None
</td>
<td style="text-align:left;">
Breiman 2001
</td>
<td style="text-align:left;">
ranger
</td>
<td style="text-align:left;">
N/A
</td>
<td style="text-align:left;">
Axis
</td>
</tr>
<tr>
<td style="text-align:left;">
Svetnik
</td>
<td style="text-align:left;">
Svetnik 2004
</td>
<td style="text-align:left;">
Uses party, code from Hapfelmeier
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Conditional Inference
</td>
</tr>
<tr>
<td style="text-align:left;">
Jiang
</td>
<td style="text-align:left;">
Jiang 2004
</td>
<td style="text-align:left;">
Uses party, code from Hapfelmeier
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Conditional Inference
</td>
</tr>
<tr>
<td style="text-align:left;">
Caret
</td>
<td style="text-align:left;">
Kuhn 2008
</td>
<td style="text-align:left;">
caret
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Axis
</td>
</tr>
<tr>
<td style="text-align:left;">
Altmann
</td>
<td style="text-align:left;">
Altmann 2010
</td>
<td style="text-align:left;">
vita
</td>
<td style="text-align:left;">
Test Based
</td>
<td style="text-align:left;">
Axis
</td>
</tr>
<tr>
<td style="text-align:left;">
Boruta
</td>
<td style="text-align:left;">
Kursa 2010
</td>
<td style="text-align:left;">
Boruta
</td>
<td style="text-align:left;">
Test Based
</td>
<td style="text-align:left;">
Axis
</td>
</tr>
<tr>
<td style="text-align:left;">
aorsf - Menze
</td>
<td style="text-align:left;">
Menze 2011
</td>
<td style="text-align:left;">
aorsf
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Oblique
</td>
</tr>
<tr>
<td style="text-align:left;">
RRF
</td>
<td style="text-align:left;">
Deng 2013
</td>
<td style="text-align:left;">
RRF
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Axis
</td>
</tr>
<tr>
<td style="text-align:left;">
SRC
</td>
<td style="text-align:left;">
Ishwaran 2014
</td>
<td style="text-align:left;">
randomForestSRC
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Axis
</td>
</tr>
<tr>
<td style="text-align:left;">
VSURF
</td>
<td style="text-align:left;">
Genuer 2015
</td>
<td style="text-align:left;">
VSURF
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Axis
</td>
</tr>
<tr>
<td style="text-align:left;">
aorsf-Negation
</td>
<td style="text-align:left;">
Jaeger 2023
</td>
<td style="text-align:left;">
aorsf
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Oblique
</td>
</tr>
<tr>
<td style="text-align:left;">
aorsf- Permutation
</td>
<td style="text-align:left;">
Jaeger 2023
</td>
<td style="text-align:left;">
aorsf
</td>
<td style="text-align:left;">
Performance Based
</td>
<td style="text-align:left;">
Oblique
</td>
</tr>
<tr>
<td style="text-align:left;">
Axis - SFE
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
ranger
</td>
<td style="text-align:left;">
Test Based
</td>
<td style="text-align:left;">
Axis
</td>
</tr>
<tr>
<td style="text-align:left;">
rfvimptest
</td>
<td style="text-align:left;">
Hapfelmeier 2023
</td>
<td style="text-align:left;">
rfvimptest
</td>
<td style="text-align:left;">
Test Based
</td>
<td style="text-align:left;">
Conditional Inference
</td>
</tr>
</tbody>
</table>

<br/>

In this benchmarking study, we pulled datasets from *OpenML* and
*modeldata* following the criteria and steps outlined below:

# Datasets included

<img src="README_files/figure-gfm/unnamed-chunk-3-1.png" width="900" />

A total of 59 datasets met criteria and were used in this benchmarking
study. Summary characteristics of these datasets are given in the figure
below

<center>

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

# Benchmarking Study

We used five replications of split sample validation (i.e., Monte-Carlo
cross validation) for each dataset to evaluate RF variable selection
methods.

1.  First, a dataset was split into training (75%) and testing (25%)
    sets.

2.  Second, each variable selection method was applied to the training
    data, and the variables selected by each method were saved.

3.  Third, a standard axis-based RF model using the R package *ranger*
    and an oblique RF using the package *aorsf* were fit on the training
    data set using variables selected from each method, and R^2 was
    recorded based on the test data for each replication, method, and
    dataset.

4.  Fourth, methods of variable selection were compared based on
    computation time, accuracy measured by R^2, and percent variable
    reduction

*note*: If any missing values were present in the training or testing
data, they were imputed prior to running variable selection methods
using the mean and mode for continuous and categorical predictors,
respectively, computed in the training data.

## Primary Results Table

We provide the results in the table below for R^2 for downstream models
fitted in Axis and Oblique RFs, variable percent reduction (higher %
reduction implies more variables eliminated on average), and computation
time (in seconds).

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:center;">
</th>
<th style="text-align:center;">
R-Squared (Axis)
</th>
<th style="text-align:center;">
R-Squared (Oblique)
</th>
<th style="text-align:center;">
Variable Percent Reduced
</th>
<th style="text-align:center;">
Time (seconds)
</th>
</tr>
</thead>
<tbody>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>Altman</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.41 ( 0.017 )<br> 0.39 \[ 0.183 , 0.626 \]
</td>
<td style="text-align:center;">
0.43 (0.018)<br>0.44 \[0.223, 0.651\]
</td>
<td style="text-align:center;">
0.75 ( 0.012 )<br> 0.82 \[ 0.667 , 0.9 \]
</td>
<td style="text-align:center;">
338.02 ( 37.636 )<br> 52.63 \[ 19.956 , 379.291 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>aorsf -<br>Menze</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.42 ( 0.018 )<br> 0.42 \[ 0.212 , 0.693 \]
</td>
<td style="text-align:center;">
0.45 (0.018)<br>0.47 \[0.233, 0.724\]
</td>
<td style="text-align:center;">
0.61 ( 0.015 )<br> 0.67 \[ 0.439 , 0.812 \]
</td>
<td style="text-align:center;">
17.8 ( 2.427 )<br> 3.57 \[ 1.198 , 12.561 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>aorsf -<br>Permutation</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.42 ( 0.019 )<br> 0.4 \[ 0.22 , 0.694 \]
</td>
<td style="text-align:center;">
0.45 (0.019)<br>0.48 \[0.236, 0.724\]
</td>
<td style="text-align:center;">
0.56 ( 0.016 )<br> 0.6 \[ 0.364 , 0.8 \]
</td>
<td style="text-align:center;">
42.67 ( 6.464 )<br> 4.91 \[ 1.145 , 24.119 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>Boruta</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.41 ( 0.019 )<br> 0.42 \[ 0.208 , 0.677 \]
</td>
<td style="text-align:center;">
0.43 (0.018)<br>0.44 \[0.225, 0.673\]
</td>
<td style="text-align:center;">
0.46 ( 0.019 )<br> 0.45 \[ 0.133 , 0.774 \]
</td>
<td style="text-align:center;">
40.58 ( 4.363 )<br> 8.35 \[ 3.519 , 47.411 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>CARET</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.43 ( 0.019 )<br> 0.42 \[ 0.23 , 0.694 \]
</td>
<td style="text-align:center;">
0.44 (0.019)<br>0.44 \[0.218, 0.681\]
</td>
<td style="text-align:center;">
0.48 ( 0.02 )<br> 0.5 \[ 0.111 , 0.826 \]
</td>
<td style="text-align:center;">
3544.69 ( 580.392 )<br> 171.95 \[ 52.846 , 1170.799 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>rfvimptest</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.18 ( 0.017 )<br> 0.08 \[ -0.005 , 0.32 \]
</td>
<td style="text-align:center;">
0.21 (0.017)<br>0.1 \[0, 0.401\]
</td>
<td style="text-align:center;">
0.92 ( 0.002 )<br> 0.93 \[ 0.9 , 0.95 \]
</td>
<td style="text-align:center;">
1068.56 ( 151.485 )<br> 143.83 \[ 35.449 , 563.047 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>Jiang</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.42 ( 0.019 )<br> 0.42 \[ 0.22 , 0.693 \]
</td>
<td style="text-align:center;">
0.44 (0.019)<br>0.44 \[0.232, 0.72\]
</td>
<td style="text-align:center;">
0.65 ( 0.015 )<br> 0.7 \[ 0.474 , 0.872 \]
</td>
<td style="text-align:center;">
455.36 ( 63.503 )<br> 41.57 \[ 14.373 , 260.241 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>SRC</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.41 ( 0.018 )<br> 0.39 \[ 0.199 , 0.666 \]
</td>
<td style="text-align:center;">
0.41 (0.018)<br>0.42 \[0.143, 0.634\]
</td>
<td style="text-align:center;">
0.35 ( 0.019 )<br> 0.27 \[ 0 , 0.667 \]
</td>
<td style="text-align:center;">
30.08 ( 1.16 )<br> 20.87 \[ 13.91 , 47.381 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>aorsf -<br>Negation</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.41 ( 0.019 )<br> 0.4 \[ 0.182 , 0.671 \]
</td>
<td style="text-align:center;">
0.44 (0.019)<br>0.41 \[0.188, 0.726\]
</td>
<td style="text-align:center;">
0.53 ( 0.016 )<br> 0.58 \[ 0.325 , 0.776 \]
</td>
<td style="text-align:center;">
44.32 ( 7.204 )<br> 5.06 \[ 1.166 , 20.333 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>None</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.4 ( 0.017 )<br> 0.4 \[ 0.182 , 0.621 \]
</td>
<td style="text-align:center;">
0.4 (0.017)<br>0.4 \[0.137, 0.635\]
</td>
<td style="text-align:center;">
0 ( 0 )<br> 0 \[ 0 , 0 \]
</td>
<td style="text-align:center;">
0 ( 0 )<br> 0 \[ 0 , 0 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>Axis -<br>SFE</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.4 ( 0.018 )<br> 0.39 \[ 0.196 , 0.624 \]
</td>
<td style="text-align:center;">
0.4 (0.017)<br>0.4 \[0.161, 0.633\]
</td>
<td style="text-align:center;">
0.13 ( 0.01 )<br> 0.05 \[ 0 , 0.243 \]
</td>
<td style="text-align:center;">
0.37 ( 0.032 )<br> 0.08 \[ 0.041 , 0.373 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>RRF</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.4 ( 0.017 )<br> 0.4 \[ 0.17 , 0.623 \]
</td>
<td style="text-align:center;">
0.4 (0.017)<br>0.39 \[0.137, 0.633\]
</td>
<td style="text-align:center;">
0.02 ( 0.004 )<br> 0 \[ 0 , 0 \]
</td>
<td style="text-align:center;">
2.43 ( 0.256 )<br> 0.6 \[ 0.152 , 2.735 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>Svetnik</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.41 ( 0.018 )<br> 0.37 \[ 0.181 , 0.642 \]
</td>
<td style="text-align:center;">
0.43 (0.018)<br>0.4 \[0.204, 0.68\]
</td>
<td style="text-align:center;">
0.69 ( 0.016 )<br> 0.76 \[ 0.577 , 0.904 \]
</td>
<td style="text-align:center;">
1197.21 ( 134.788 )<br> 245.47 \[ 76.233 , 1317.819 \]
</td>
</tr>
<tr grouplength="1">
<td colspan="5" style="border-bottom: 0px solid;">
<strong>VSURF</strong>
</td>
</tr>
<tr>
<td style="text-align:center;padding-left: 2em;" indentlevel="1">
Mean (SD)<br>Median \[IQR\]
</td>
<td style="text-align:center;">
0.43 ( 0.018 )<br> 0.41 \[ 0.205 , 0.69 \]
</td>
<td style="text-align:center;">
0.43 (0.019)<br>0.43 \[0.216, 0.714\]
</td>
<td style="text-align:center;">
0.76 ( 0.014 )<br> 0.84 \[ 0.707 , 0.918 \]
</td>
<td style="text-align:center;">
256.19 ( 41.346 )<br> 23.71 \[ 8.851 , 125.959 \]
</td>
</tr>
</tbody>
</table>

## Primary Results Figure

We present the results of accuracy, by time, and percent reduction in
the figure below. K-Means clustering was used to find the cluster of
methods that perform best optimally in terms of computation time and
accuracy (in the bottom right corner of the figure), with size and color
denoting percent reduction.

<img src="README_files/figure-gfm/unnamed-chunk-6-1.png" width="1038" />

We observe that for downstream Axis forests fitted in *ranger*, the
methods of Boruta (r package: *boruta*) and aorsf-Menze (r package:
*aorsf*) perform optimmaly in terms of fast computation time and
high-accuracy while preserving good parsimony (good variable percent
reduction).

For downstream oblique forests fitted in *aorsf*, the methods
aorsf-Menze and aorsf-Permutation (both found within the *aorsf* R
package) perform best in terms of computation time and accuracy.

## Sensitivity to incomplete replication

We note that in several dataset replications, at least one method failed
to select a single variable in variable selection. We performed a
sensitivity analysis by assessing results only in replications where all
methods selected at least one variable (2,464 out of 4,260)

<img src="README_files/figure-gfm/unnamed-chunk-7-1.png" width="1038" />

## Comparison of Axis vs Oblique fitted downstream RFs

Last but not least, we compare downstream fitted Axis RFs to Oblique
RFs.

<img src="README_files/figure-gfm/unnamed-chunk-8-1.png" width="773" />

We find that in terms of median accuracy, downstream oblique fitted
forests generally perform slightly better than downstream Axis forests,
particularly among the top performing methods of variable selection.
