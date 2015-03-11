TRANSVIZ v2.01
by Christopher Wilson
cwils16@u.rochester.edu

Compatibility Note:
This version of TRANSVIZ was written in Matlab version R2013a.  Several of the coding methods used are not compatible in newer 
versions of Matlab, such as version R2014b.  In terms of forward compatibility usage, this code should be rewritten in Python,
since Matlab clearly does not provide a stable long-term coding platform.

About TRANSVIZ:
TRANSVIZ is a Matlab GUI designed to provide an easy means of reading and visualizing data from TRANSP runs written in the  NETCDF format.  The motivation for creating this program came after observing how cumbersome it was to visualize TRANSP output using the command line program RPlot.  While TRANSVIZ does not contain all of the advanced functionality found in RPlot, it does provide a massive improvement over RPlot's basic plotting features.  In particular, TRANSVIZ utilizes a slider to quickly change time or position slices within the data, so that plotted data can be quickly updated and compared under various conditions.  Additionally, TRANSVIZ is able to plot up to six variables at once from any arrangement of different CDF files.  TRANSVIZ also provides access to a sortable list of all variables found in a TRANSP CDF.  Moreover, all of this data is easily exportable to text and image formats through the TRANSVIZ interface for further processing.

Installing TRANSVIZ:
TRANSVIZ does not require a formal install.  The program can be started by just running the TRANSVIZ executable file.  Those who are more familiar with Matlab can download the source code and run TRANSVIZ through the Matlab interface.