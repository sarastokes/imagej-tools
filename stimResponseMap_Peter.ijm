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
	Dialog.addNumber("Baseline Start:", 20);
	Dialog.addNumber("Baseline End", 498);
	Dialog.addNumber("Stim Start:", 502);
	Dialog.addNumber("Stim End:", 998);
	// The 2nd input to addNumber() is the default value that will 
	// show up in the dialog box, in case you want to edit that
Dialog.show();


videoID = Dialog.getNumber();
baselineStart = Dialog.getNumber();
baselineEnd = Dialog.getNumber();
stimStart = Dialog.getNumber();
stimEnd = Dialog.getNumber();


// Work from the active stack
stackTitle = getTitle();
print("Stim Response: " + stackTitle);

// Get the average response before the stimulus
run("Z Project...", "start=" + baselineStart + " stop=" + baselineEnd + " projection=[Average Intensity]");
baselineImage = getTitle();

// Get the average response during the stimulus
selectWindow(stackTitle);
run("Z Project...", "start=" + stimStart + " stop=" + stimEnd + " projection=[Average Intensity]");
stimImage = getTitle();

// Subtract the baseline from the response during the stimulus
imageCalculator("Subtract create 32-bit", stimImage, baselineImage);
rename("onset_" + videoID);
onsetImage = getTitle();

// Narrow dynamic range to signal present
run("Enhance Contrast", "saturated=0.35");
// Make dynamic range symmetric around 0 so positive and negative 
// changes appear similarly distinct and 0 (no change) corresponds
// to the middle value of the LUT/colormap
getMinAndMax(min1, max1);
finalBound = maxOf(abs(min1), max1);
finalMin = -1 * finalBound;
setMinAndMax(finalMin, finalBound);

// Close out the intermediate images
selectWindow(stimImage);
close();
selectWindow(baselineImage);
close();

