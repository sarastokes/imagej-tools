// stimResponseMap.ijm
// 17Oct2021 - SSP
// 02Nov2021 - SSP - Removed call to Math package
// 22Dec2021 - SSP - Default close of image stack

Dialog.create("Stimulus Response");
	// For each pixel, the mean during the Baseline frames will be 
	// subtracted from the mean during the Stim frames. I find dF is
	// clearer for pixel-wise calculations than dF/F.
	// The 2nd input to addNumber() is the default value that will 
	// show up in the dialog box, in case you want to edit that
	Dialog.addMessage("Enter stimulus parameters here, in frames:");
	Dialog.addNumber("Stim Start:", 500);
	Dialog.addNumber("Stim End:", 750);
	Dialog.addCheckbox("Compute offset response:", true);
	Dialog.addNumber("Offset end:", 1000);
	Dialog.addCheckbox("Magenta-green colors?", false);
	// Added to the titles of created figures, not necessary but useful 
	// if you're going to run this multiple times and want to easily
	// tell the output figures apart.
	Dialog.addNumber("ID", 1);
	Dialog.addCheckbox("Close video after?", true);
Dialog.show();

stimStart = Dialog.getNumber();
stimEnd = Dialog.getNumber();
computeOffset = Dialog.getCheckbox();
stimOffset = Dialog.getNumber();
whichColors = Dialog.getCheckbox();
videoID = Dialog.getNumber();
closeVideo = Dialog.getCheckbox();

baselineEnd = stimStart - 1;

// Work from the active stack
stackTitle = getTitle();
print("Stim Response: " + stackTitle);

// Get the average response before the stimulus
run("Z Project...", "start=2 stop=" + baselineEnd + " projection=[Average Intensity]");
baselineImage = getTitle();

// Get the average response during the stimulus
selectWindow(stackTitle);
run("Z Project...", "start=" + stimStart + " stop=" + stimEnd + " projection=[Average Intensity]");
stimImage = getTitle();

// Subtract the baseline from the response during the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("onset_" + videoID);
onsetImage = getTitle();
run("Enhance Contrast", "saturated=0.35");
getMinAndMax(min1, max1);

if (computeOffset) {
	offsetBegin = stimEnd + 1;
		
	// Get the average response after the stimulus
	selectWindow(stackTitle);
	run("Z Project...", "start=" + offsetBegin + " stop=" + stimOffset + " projection=[Average Intensity]");
	tailImage = getTitle();
	
	// Subtract the baseline from the response after the stimulus
	imageCalculator("Subtract create 32-bit", tailImage, baselineImage);
	rename("offset_" + videoID);
	offsetImage = getTitle();
	run("Enhance Contrast", "saturated=0.35");
	getMinAndMax(min2, max2);

	// Match the pixel ranges
	// Makes dynamic range symmetric around 0 so positive and negative 
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
	
	selectWindow(onsetImage);
	setMinAndMax(finalMin, finalBound);
	selectWindow(offsetImage); 
	setMinAndMax(finalMin, finalBound);
	
	// Create a merged image
	if (whichColors) {
		run("Merge Channels...", "c2=[" + onsetImage + "] c6=[" + offsetImage + "] create keep");
	} else {
		run("Merge Channels...", "c1=[" + offsetImage + "] c5=[" + onsetImage + "] create keep");
	}
	rename("Merged_" + videoID);
	// Cleanup
	selectWindow(tailImage);
	close();
} else {
	// Makes dynamic range symmetric around 0 so positive and negative 
	// changes appear similarly distinct and 0 (no change) corresponds
	// to the middle value of the LUT/colormap
	finalBound = maxOf(abs(min1), max1);
	finalMin = -1 * finalBound;
	setMinAndMax(finalMin, finalBound);
}

// Cleanup
selectWindow(stimImage);
close();
selectWindow(baselineImage);
close();

if (closeVideo) {
	selectWindow(stackTitle);
	close();
}

