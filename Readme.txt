This code is tested on 64 bit Matlab R2013b running on 64 bit Windows 7. Some portions require parallel processing in Matlab.

Please cite the following paper if you use the code.
Syed, Sohaib Ali, Muhammad Zafar Iqbal, and Muhammad Mohsin Riaz. "Describing contrast across scales." ISPRS Journal of Photogrammetry and Remote Sensing 128 (2017): 326-337. 
(http://www.sciencedirect.com/science/article/pii/S0924271616305597)

1) Extract the zip file and make it as current directory in Matlab.

2) If you want to load pre-calculated features, then jump to step 3, else do the following.....
	- Download dataset from http://www-cvr.ai.uiuc.edu/ponce_grp/data/ and extract all images in a folder. Set this folder path in learn_vocab.m and extract_features.m.
	- Download Vlfeat from http://www.vlfeat.org/download/vlfeat-0.9.19-bin.tar.gz and extract in a folder. Set the path of the setup file in learn_vocab.m and extract_features.m.
	- Run learn_vocab.m to learn the dictionary. 
	- Run extract_features.m to extract features from all of the images.  

3) Run demo3.m to test the classification on different set of training and testing images.