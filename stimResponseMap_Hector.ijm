// stimResponseMap.ijm
// 17Oct2021 - SSP
// 02Nov2021 - SSP - Removed call to Math package
// 16Dec2021 - SSP - Added comments and removed aspects irrelevant to 
//					 single RGC stimulation experiments

Dialog.create("Stimulus Response");
	// Added to the titles of created figures, not necessary but useful 
	// if you're going to run this multiple times and want to easily
	// tell the output figures apart.
	Dialog.addNumber("ID", 1);

	// For each pixel, the mean during the Baseline frames will be 
	// subtracted from the mean during the Stim frames. I find dF is
	// clearer for pixel-wise calculations than dF/F.
	Dialog.addMessage("Enter stimulus parameters here, in frames:");
	Dialog.addNumber("Baseline Start:", 300);
	Dialog.addNumber("Baseline End", 498);
	Dialog.addNumber("Up Start:", 2024);
	Dialog.addNumber("Up End:", 2529);
    Dialog.addNumber("Down Start:", 2530);
    Dialog.addNumber("Down End:", 3035);
	Dialog.addCheckbox("Red-cyan colors?", false);
	// The 2nd input to addNumber() is the default value that will 
	// show up in the dialog box, in case you want to edit that
Dialog.show();


videoID = Dialog.getNumber();
baselineStart = Dialog.getNumber();
baselineEnd = Dialog.getNumber();
upStart = Dialog.getNumber();
upEnd = Dialog.getNumber();
downStart = Dialog.getNumber();
downEnd = Dialog.getNumber();
whichColors = Dialog.getCheckbox();


// Work from the active stack
stackTitle = getTitle();
print("Stim Response: " + stackTitle);

// Get the average response before the stimulus
run("Z Project...", "start=" + baselineStart + " stop=" + baselineEnd + " projection=[Average Intensity]");
baselineImage = getTitle();


// FIRST RESPONSE ---------------------------------------------------
// Get the average response during the stimulus
selectWindow(stackTitle);
run("Z Project...", "start=" + upStart + " stop=" + upEnd + " projection=[Average Intensity]");
stimImage = getTitle();

// Subtract the baseline from the response during the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("onset_" + videoID);
upImage = getTitle();
// Narrow dynamic range to the signal present, get range
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(min1, max1);

// Close the intermediate image
selectWindow(stimImage);
close();

// SECOND RESPONSE --------------------------------------------------
// Get the average response
selectWindow(stackTitle);
run("Z Project...", "start=" + downStart + " stop=" + downEnd + " projection=[Average Intensity]");
stimImage = getTitle();

// Subtract the baseline from the response after the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("offset_" + videoID);
downImage = getTitle();
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(min2, max2);

// Close the intermediate image
selectWindow(stimImage);
close();

// FORMATTING -------------------------------------------------------
// Make dynamic range symmetric around 0 so positive and negative 
// changes appear similarly distinct and 0 (no change) corresponds
// to the middle value of the LUT/colormap
finalMax = max2;
if (max1 > max2) {
    finalMax = max1;
}
finalMin = min2;
if (min1 < min2) {
    finalMin = min1;
}
finalBound = maxOf(abs(finalMin), finalMax);
finalMin = -1 * finalBound;
getMinAndMax(min1, max1);
finalBound = maxOf(abs(min1), max1);
finalMin = -1 * finalBound;
setMinAndMax(finalMin, finalBound);
selectWindow(upImage);
setMinAndMax(finalMin, finalBound);
selectWindow(downImage); 
setMinAndMax(finalMin, finalBound);

// MERGED IMAGE -----------------------------------------------------
// Create a merged image
if (whichColors) {
    run("Merge Channels...", "c2=[" + upImage + "] c6=[" + downImage + "] create keep");
} else {
    run("Merge Channels...", "c1=[" + downImage + "] c5=[" + upImage + "] create keep");
}
rename("Merged_" + videoID);

// Close out the intermediate images
selectWindow(baselineImage);
close();
