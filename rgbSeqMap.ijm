// stimResponseMap.ijm
// 17Oct2021 - SSP
// 02Nov2021 - SSP - Removed call to Math package
// 16Dec2021 - SSP - Added comments and removed aspects irrelevant to 
//					 single RGC stimulation experiments
// 23Feb2022 - SSP - Modified for RGB seq stimulus

Dialog.create("Stimulus Response");
	// Added to the titles of created figures, not necessary but useful 
	// if you're going to run this multiple times and want to easily
	// tell the output figures apart.
	Dialog.addNumber("ID", 1);

	// For each pixel, the mean during the Baseline frames will be 
	// subtracted from the mean during the stimulus. I find dF is
	// clearer for pixel-wise calculations than dF/F.
	Dialog.addMessage("Enter stimulus parameters here, in frames:");
	Dialog.addNumber("Baseline Start:", 300);
	Dialog.addNumber("Baseline End", 498);
Dialog.show();


videoID = Dialog.getNumber();
baselineStart = Dialog.getNumber();
baselineEnd = Dialog.getNumber();

// Work from the active stack
stackTitle = getTitle();
print("Stim Response: " + stackTitle);

// Get the average response before the stimulus
run("Z Project...", "start=" + baselineStart + " stop=" + baselineEnd + " projection=[Average Intensity]");
baselineImage = getTitle();




// ---
// RED
// ---
// FIRST RESPONSE -------------------------------------------------
// Get the average response during the stimulus
selectWindow(stackTitle);
run("Z Project...", "start=" + 507 + " stop=" + 632 + " projection=[Average Intensity]");
stimImage = getTitle();

// Subtract the baseline from the response during the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("red_onset_" + videoID);
redUpImage = getTitle();
// Narrow dynamic range to the signal present, get range
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(redMin, redMax);

// Close the intermediate image
selectWindow(stimImage);
close();

// SECOND RESPONSE --------------------------------------------------
// Get the average response
selectWindow(stackTitle);
run("Z Project...", "start=" + 633 + " stop=" + 758 + " projection=[Average Intensity]");
stimImage = getTitle();

// Subtract the baseline from the response after the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("red_offset_" + videoID);
redDownImage = getTitle();
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(min2, max2);

// Close the intermediate image
selectWindow(stimImage);
close();

// FORMATTING ----------------------------------------------------
// Make dynamic range symmetric around 0 so positive and negative 
// changes appear similarly distinct and 0 (no change) corresponds
// to the middle value of the LUT/colormap
finalMax = max2;
if (redMax > max2) {
    finalMax = redMax;
}
finalMin = min2;
if (redMin < min2) {
    finalMin = redMin;
}
finalBound = maxOf(abs(finalMin), finalMax);
finalMin = -1 * finalBound;
getMinAndMax(min1, max1);
finalBound = maxOf(abs(min1), max1);
finalMin = -1 * finalBound;
setMinAndMax(finalMin, finalBound);
selectWindow(redUpImage);
setMinAndMax(finalMin, finalBound);
selectWindow(redDownImage); 
setMinAndMax(finalMin, finalBound);


// MERGED IMAGE ------------------------------------------------------
// Create a merged image
run("Merge Channels...",  "c1=[" + redUpImage + "] c5=[" + redDownImage + "] create keep");
rename("red_merged_" + videoID);

// -----
// GREEN
// -----

// FIRST RESPONSE -------------------------------------------------
// Get the average response during the stimulus
selectWindow(stackTitle);
run("Z Project...", "start=" + 1012 + " stop=" + 1138 + " projection=[Average Intensity]");
stimImage = getTitle();


// Subtract the baseline from the response during the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("green_onset_" + videoID);
greenUpImage = getTitle();
// Narrow dynamic range to the signal present, get range
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(greenMin, greenMax);

// Close the intermediate image
selectWindow(stimImage);
close();


// SECOND RESPONSE --------------------------------------------------
// Get the average response
selectWindow(stackTitle);
run("Z Project...", "start=" + 1139 + " stop=" + 1265 + " projection=[Average Intensity]");
stimImage = getTitle();

// Subtract the baseline from the response after the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("green_offset_" + videoID);
greenDownImage = getTitle();
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(min2, max2);

// Close the intermediate image
selectWindow(stimImage);
close();


// FORMATTING ----------------------------------------------------
// Make dynamic range symmetric around 0 so positive and negative 
// changes appear similarly distinct and 0 (no change) corresponds
// to the middle value of the LUT/colormap
finalMax = max2;
if (greenMax > max2) {
    finalMax = greenMax;
}
finalMin = min2;
if (greenMin < min2) {
    finalMin = greenMin;
}
finalBound = maxOf(abs(finalMin), finalMax);
finalMin = -1 * finalBound;
getMinAndMax(min1, max1);
finalBound = maxOf(abs(min1), max1);
finalMin = -1 * finalBound;
setMinAndMax(finalMin, finalBound);
selectWindow(greenUpImage);
setMinAndMax(finalMin, finalBound);
selectWindow(greenDownImage); 
setMinAndMax(finalMin, finalBound);

// MERGED IMAGE ------------------------------------------------------
// Create a merged image
run("Merge Channels...", "c2=[" + greenUpImage + "] c6=[" + greenDownImage + "] create keep");
rename("green_merged_" + videoID);




// ----
// BLUE
// ----

// FIRST RESPONSE -------------------------------------------------
// Get the average response during the stimulus
selectWindow(stackTitle);
run("Z Project...", "start=" + 1518 + " stop=" + 1644 + " projection=[Average Intensity]");
stimImage = getTitle();


// Subtract the baseline from the response during the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("blue_onset_" + videoID);
blueUpImage = getTitle();
// Narrow dynamic range to the signal present, get range
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(blueMin, blueMax);

// Close the intermediate image
selectWindow(stimImage);
close();


// SECOND RESPONSE --------------------------------------------------
// Get the average response
selectWindow(stackTitle);
run("Z Project...", "start=" + 1645 + " stop=" + 1771 + " projection=[Average Intensity]");
stimImage = getTitle();

// Subtract the baseline from the response after the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("blue_offset_" + videoID);
blueDownImage = getTitle();
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(min2, max2);

// Close the intermediate image
selectWindow(stimImage);
close();

// FORMATTING ----------------------------------------------------
// Make dynamic range symmetric around 0 so positive and negative 
// changes appear similarly distinct and 0 (no change) corresponds
// to the middle value of the LUT/colormap
finalMax = max2;
if (blueMax > max2) {
    finalMax = blueMax;
}
finalMin = min2;
if (blueMin < min2) {
    finalMin = blueMin;
}
finalBound = maxOf(abs(finalMin), finalMax);
finalMin = -1 * finalBound;
getMinAndMax(min1, max1);
finalBound = maxOf(abs(min1), max1);
finalMin = -1 * finalBound;
setMinAndMax(finalMin, finalBound);
selectWindow(blueUpImage);
setMinAndMax(finalMin, finalBound);
selectWindow(blueDownImage); 
setMinAndMax(finalMin, finalBound);

// MERGED IMAGE ------------------------------------------------------
// Create a merged image
run("Merge Channels...", "c3=[" + blueUpImage + "] c7=[" + blueDownImage + "] create keep");
rename("blue_merged_" + videoID);

// ------------
// TRICHROMATIC  
// ------------

// FORMATTING ----------------------------------------------------
// Make dynamic range symmetric around 0 so positive and negative 
// changes appear similarly distinct and 0 (no change) corresponds
// to the middle value of the LUT/colormap
finalMax = redMax;
if (greenMax > redMax) {
    finalMax = greenMax;
}
if (blueMax > greenMax) {
	finalMax = blueMax;
}

finalMin = redMin;
if (greenMin < redMin) {
    finalMin = greenMin;
}
if (blueMin > greenMin) {
	finalMin = blueMin;
}
finalBound = maxOf(abs(finalMin), finalMax);
finalMin = -1 * finalBound;
selectWindow(redUpImage);
setMinAndMax(finalMin, finalBound);
selectWindow(greenUpImage);
setMinAndMax(finalMin, finalBound);
selectWindow(blueUpImage);
setMinAndMax(finalMin, finalBound);
// MERGED IMAGE --------------------------------------------------
run("Merge Channels...", "c1=[" + redUpImage + "] c2=[" + greenUpImage + "] c3=[" + blueUpImage + "]  create keep");
rename("rgb_onset_merged_" + videoID);

// Close out the intermediate images
selectWindow(baselineImage);
close();

