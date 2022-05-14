# CSE4019-ImageProcessing-Project
To manipulate the shadow pixel according to its non-shadow mapping for an effective shadow removal of an image and output the image without any dark texture due to presence of shadow.


How to view the code:
-->The MATLAB Folder consists of the code to detect, correct, remove and replace the shadow pixels from an image.
-->The img folder consists of sample images for our usecase.
-->The feature folder contains matlab code of inbuilt functions and methods for extracting image features from input images.

The following are the various algorithmics apporaches undertaken in sequence to retrive the final output image:

Algorithms:

Area matching calculation
Since features such as color and saturation will vary with whether the area has shadows or not, the target is looking for two areas with the most similar materials. 
So considering the shadow invariant features: gradient features, texture features.
Gradient feature: The gradient of the image area is hardly affected by whether it is a shadow area. The similarity of gradients between regions with similar textures is stronger. In order to extract this feature, we calculated a histogram of the gradient value of each region of the image.
Texture features: The image surface texture feature is almost independent of shadows. Texton method  by David R Martin, Charless C Fowlkes, and Jitendra Malik in Learning to detect natural image boundaries using local brightness, color, and texture cues( IEEE transactions on pattern analysis and machine intelligence) is used to extract the texture features. 
Similarly, the similarity between regions is measured by calculating the Manhattan distance between the histograms of two regions.
Distance between regions: In order to ensure local consistency, the distance between the midpoints of the two regions is added as a factor for judging the similarity of the regions.
The similarity between regions i and j is calculated as follows:
D i,j = Dgradient i,j + Dtexture i,j + Ddistance i,j 

Shadow detection
The overall idea is that one side judges the shadow based on features, and the other side judges the shadow based on the mutual restriction between regions.
Feature Selection
Y channel information in YCbCr color space Convert the original image from RGB color space to YCbCr color space. When the value of a pixel on the Y channel of the YCbCr space is less than 60% of the average value of the Y channel of the entire image, it can be directly considered as being in the shadow. When the average Y channel of a region is less than 60% of the average Y channel of the entire image, I think this region is in the shadow. Take the average value in the area Si, and mark the feature as Yi.
HSI color space information The original image is converted from RGB space to HSI space. Then normalize the values on the H and I channels to the interval [0, 1] to obtain He, Ie. Take the average value of the area Si and mark the feature as Ri.

R(x,y) = He(x,y) / Ie(x,y)

* Use the mean shift algorithm to segment the image. Each area is denoted as Si and the center is Ci, totaling n areas;
* Calculate the difference Di,j between Si and Sj to calculate the corresponding area with the highest similarity for each area, which is recorded as Near(i). At the same time, record the information labeli of whether the area i is a shadow, and it is initialized to 1;
* For all Ri, 1 <i <n, use kmeans clustering to calculate two centers C(shadow) and C(lit), which respectively represent whether they are the feature centers of the shaded area. Assuming that the feature R obeys a normal distribution, the standard deviations Std(shadow) and Std(lit) corresponding to C(shadow) and Clit are calculated. Therefore, for each Ri, the confidence F(shadow), Flit belonging to C(shadow) and C(lit) can be calculated.
* For each area Si, Refuse(i) represents whether it is called a shadow area because other areas are prohibited, and it is initialized to 0.
Steps
1)Extract features Yi, Ri and prepare relevant variables
2)If Yi <60% ∗ mean(Yimage), then labeli = shadow
3)Select the area Si with the largest Fshadow and Refusei = 0, and set labeli = shadow
4)Let Si's nearest area Neari be Sj, check whether Si and Sj are the opposite areas of light by comparing Ri, Rj, if yes, judge Refusej = 1
5)Repeat steps 3)-4) repeatedly until there are no more updates
6)For Si with labeli = shadow, by comparing Yi, Yj, Ri, Rj, if it is judged that Si and Sj are similar in brightness, and Refusej = 0, set labelj = 0.


Shadow Removal
Shadow removal is mainly performed in HSV color space. The overall idea is to find the corresponding Sj for the shadow area Si, with full labelj = 1 and Di,j the smallest. Therefore, Sj is the non-shaded area that is most similar to Si. Consider using Sj to adjust the brightness of Si, through the histogram matching algorithm, remove the shadow on Si, and at the same time minimize the impact of the operation on other features.
Histogram Matching
Suppose the feature of area Si is Featurei, and the template histogram HistT is given. The purpose of matching the histogram is to ensure that the distribution of Featurei varies the most, and the overall offset conforms to the distribution of the template T. The specific method is as follows.
1) Calculate the histogram Histi of Featurei with the number of stripes equal to T;
2) Calculate cumulative histograms Acci, AccT for Histi and HistT respectively;
3) For each fringe p in Acci, calculate the fringe sequence number q with the smallest difference between Acct
4) Move each stripe p to the position of q as a whole.
Steps:
1) Calculate the shadow detection result label, and convert the image to HSV space at the same time
2) Repeat steps 3)-5) for each shadow area Si
3) For the area Si, find that Sj is full labelj = 1 and Di,j is the smallest, use Sj to brighten Si
4) For each channel H, S, I of the HSV color space, calculate the histogram HistH,j, HistS,j, HistI,j of Sj
5) Using HistH,j, HistS,j, HistI,j as the template for matching the histogram, adjust the three features of Si to make the feature distribution close to the template
6) Convert the image to RGB space
7) Calculate the intersection boundary between all shadow areas and non-shaded areas in the image, and then smooth all the boundaries.

