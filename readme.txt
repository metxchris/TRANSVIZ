Two versions of TRANSVIZ exist due to the incompatibility of the new R2014b graphics engine with the older engine in R2013a.  The differences between each TRANSVIZ Matlab version are:

[R2014b]
	- Figures (especially several line options) and text look much better as compared to the R2013a version.  Legends have a semi-transparent background; a line-transparency option was added.
	- Figures and exported .eps files are less glitchy.
	- The compiled executable comes with a loading splash screen, and will prompt the user to download the appropriate Matlab compiler runtime (MCR) if needed.
	- Known Bug: .eps figure exports have additional white space; this will need to be manually cropped afterwards.
	- Known Bug: Quickly clicking through variables in the variable or pointerlist will cause TRANSVIZ to freeze for a few seconds and then produce an error.
	- Known Bug: To avoid another random bug, plot updating has been disabled when clicking on variables in the pointer list window.
	
[R2013a]
	- Uses older graphics engine with limited capabilities and several glitches, as compared to the newer R2014b graphics engine.
	- The compiled executable has no loading splash screen; the user must wait upwards of a minute with no feedback while the MCR is loaded.
	- Known Bug: OpenGL rendering will fail and produce no output for variables with either very large or very small magnitudes.  This rarely occurs though, and switching to painters mode fixes the issue.
   