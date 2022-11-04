// STACK_COLOR_OFFSET.IJM
//
// Creates 2 color images showing each image and the image before it
// History:
//	04Nov2022 - SSP

// NOTE: CLOSE ALL SINGLE IMAGES (IE NOT STACK) BEFORE RUNNING

// Work from the active stack
stackTitle = getTitle();
n = nSlices;

for (i=2; i<=n; i++) {
	selectWindow(stackTitle);
	run("Make Substack...", "slices=1");
	subTitle1 = getTitle();
	run("Enhance Contrast", "saturated=0.35");
	
	selectWindow(stackTitle);
	run("Make Substack...", "slices=" + i);
	subTitle2 = getTitle();
	run("Enhance Contrast", "saturated=0.35");
	
	run("Merge Channels...", "c2=[Substack (1)] c6=[Substack (" + i + ")] create");
	compTitle = getTitle();
	
	run("Stack to RGB");
	rename("offset_1_" + i);
	
	selectWindow(compTitle);
	close();
	// Return to the stack window
	selectWindow(stackTitle);
}

// Concatenate all the images into a single stack
run("Images to Stack");


