# OpticalFlowAnalysis

## Introduction
This code is adapted from the manuscript ["Quantifying topography-guided actin dynamics across scales using optical flow" by Lee*, Campanello*, Hourwitz, Alvarez, Omidvar, Fourkas and Losert.][1] The original code used in the manuscript is posted by [@LosertLab](https://github.com/losertlab) at [https://github.com/losertlab/flowclustertracking](https://github.com/losertlab/flowclustertracking).

The current version of the code is written in MATLAB and only applicable to 2-D data. A Python version is in the works.

## Workflow

The workflow is managed by ControlScript.m (ControlScript_sample.m for the example data). Detailed explanations of all predefined parameters in the control script can be found in Parameters.txt.

### "MainAnalysisScript.m"

"MainAnalysisScript.m" receives the parameters from ControlScript.m and performs all of the main functions of the analysis workflow.

#### Importing data
Data must be saved in a single-channel multistack .tif such that "imread('FILENAME.tif', n)" loads frame "n" of the time series.

#### Calculating optical flow
Optical flow is calculated using the [Lucas-Kanade method][2]. The Lucas-Kanade method assumes that local spatial and temporal image gradients can be modeled as a linear translation of intensity between two adjacent frames.

<video width="480" height="320" controls="controls">
  <source src="https://github.com/ljcamp1624/OpticalFlowAnalysis/blob/master/AI1_2/MovieFolder/Original Images and Optical Flow.mp4" type="video/mp4">
</video>

The optical-flow calculation here uses a derivative-of-Gaussian (DoG) kernel to calculate spatial and temporal image gradients, and solves for the best estimate of optical flow using least-squares criteria. The DoG kernel assures that pixel noise does not result in overly noise optical flow.

The Lucas-Kanade method prescribes that local spatial and temporal gradients be accumulated in the calculation step using a window of a predefined size. Here, we applied an additional gaussian weight matrix to ensure that optical-flow vectors indicated by pixels at the center of the window carried more information than those far away from the central pixel.

Optical-flow reliability is a measure of certaintly in the flow calculation. Low reliability indicates that the optical-flow calculation has encountered the aperture problem. Here, we define the reliability as the smaller eigenvalue of the Lucas-Kanade structure tensor. Alternatively, one may use optical-flow coherence as a measure of quality (defined as the absolute value of the difference of the eigenvalues divided by their sum), which is included as a currently unused output of LKxOpticalFlow_allFrames.m.

#### Clustering images
Optical-flow clusters were calculated by superimposing optical-flow alignment on regions of protruding dynamic behavior. 

Optical-flow alignment was calculated by taking the weighted sum of the dot product between optical-flow vectors with neighboring vectors. The alignment metric uses a gaussian weight matrix so that alignment in a central pixel is largely comprised of information from nearby pixels.

Protruding regions were defined as areas where the difference image of overly smoothed images is positive. Thus, the workflow first calculates the "SmoothImages" and then the "DifferenceImages."


#### Tracking of clusters
Tracking was performed using the [Crocker-Grier particle-tracking algorithm][3] translated to [MATLAB][4]. Tracking is performed on peak optical-flow alignment within optical flow clusters, but can be alternatively performed on binary images by thresholding the '''clusterIm*''' variables before tracking.




[1]: https://doi.org/10.1091/mbc.E19-11-0614
[2]: https://dl.acm.org/doi/10.5555/1623264.1623280
[3]: http://crocker.seas.upenn.edu/CrockerGrier1996b.pdf
[4]: http://site.physics.georgetown.edu/matlab/
