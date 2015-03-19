Note: Still Under Construction.

###Introduction: 

TRANSVIZ is a Matlab GUI designed to provide an easy means of reading and visualizing data from TRANSP runs written in the  NETCDF format.  The motivation for creating this program came after observing how cumbersome it was to visualize TRANSP output using the command line program RPlot.  While TRANSVIZ does not contain all of the advanced functionality found in RPlot, it does provide a massive improvement over RPlot's basic plotting features.  In particular, TRANSVIZ utilizes a slider to quickly change time or position slices within the data, so that plotted data can be quickly updated and compared under various conditions.  Additionally, TRANSVIZ is able to plot up to six variables at once from any arrangement of different CDF files.  TRANSVIZ also provides access to a sortable list of all variables found in a TRANSP CDF.  Moreover, all of this data is easily exportable to text and image formats through the TRANSVIZ interface for further processing.

###Matlab version differences:
Two versions of TRANSVIZ exist due to the incompatibility of the new R2014b graphics engine with the older engine in R2014a.  The differences between each TRANSVIZ Matlab version are:

* R2014b:
 * Figures (especially several line options) and text look much better as compared to the R2014a version.  Legends have a semi transparent background; a line transparency option was added.
 * Figures and exported .eps files are less glitchy.
 * Known Bug: .eps figure exports have additional white space; this will need to be manually cropped afterwards.
 * Known Bug: To avoid another random bug, plot updating has been disabled when clicking on variables in the pointer list window.

* R2014a:
 * Uses older graphics engine with limited capabilities and several glitches, as compared to the newer R2014b graphics engine.
 * Known Bug: OpenGL rendering will fail and produce no output for variables with either very large or very small magnitudes.  This rarely occurs though, and switching to painters mode fixes the issue.