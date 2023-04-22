<h1>ROI Extraction and Feature Extraction Readme</h1>
</head>
<body>
	<p>This repository contains code for extracting ROI and extracting features using Gabor filters for oral cancer screening.</p>
<h2>ROI Extraction</h2>
<p>To extract ROI for malignant, non-malignant, and normal images, <span style="background-color:yellow">run main_file.m, main_file_2.m, and main_file_3.m </span> respectively. These files call the following sub-functions:</p>
<ul>
	<li>frontface.m: This function calls the following sub-functions:</li>
	<ul>
		<li>face_detect.m</li>
		<li>eye_detection_thermal.m</li>
		<li>mouth_detection.m</li>
		<li>mouth_row_detect.m</li>
		<li>Connected_Components_Face.m</li>
		<li>hull_Mask.m</li>
		<li>lower_Eye_Regression.m</li>
	</ul>
	<li>side_face.m: This function calls the following sub-functions:</li>
	<ul>
		<li>kittlerMinimimErrorThresholding.m</li>
		<li>find_neck.m</li>
		<li>nose_tip.m</li>
		<li>nose_tip_copy.m</li>
		<li>modified_mask.m</li>
		<li>chin_new.m</li>
		<li>uppper_nose.m</li>
		<li>ear_new.m</li>
	</ul>
</ul>
<p>This function creates a directory to store the extracted images of the ROI. The extracted ROI images are saved in the ROI_Images folder.</p>

<h2>Feature Extraction</h2>
<p>To extract features from the ROI images using Gabor filters, run main_gabor_malignant.m, main_gabor_non_malignant.m, and main_gabor_normal.m respectively. These files call the following sub-function:</p>
<ul>
	<li>gabor_self.m: This function extracts Gabor features from the ROI images and returns a CSV file with the extracted features for all the images.</li>
</ul>
<p>The extracted CSV files are saved in the Results/image_processing_csv_files folder.</p>

<h2>Multiresolution and Multimodal Classification</h2>
<p>To perform multiresolution classification, run gabor_features_concatenation.m to concatenate the features for different scales for every subject for each class.</p>

<p>To perform image processing classification, run gabor_main_profile.m to generate a common feature extracted file classwise and perform image processing classification. The results are stored in results/image_classification_results_old_and_new.</p>

<p>To perform metadata classification, run the notebooks in /results/meta_dataset_binary_results.</p>

<p>To perform multimodal classification, run multimodal_code/main.</p>

<p>All the results generated from these classifications are stored in the results folder.</p>
