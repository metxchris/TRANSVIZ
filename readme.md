Documentation available at: [https://github.com/metxchris/TRANSVIZ/wiki](https://github.com/metxchris/TRANSVIZ/wiki "wiki").

*Version Notes:* Two versions of TRANSVIZ exist due to the incompatibility of the new R2014b graphics engine with the older engine in R2014a.  The differences between each TRANSVIZ Matlab version are:

* R2014b:
 * Figures (especially several line options) and text look much better as compared to the R2014a version.  Legends have a semi transparent background; a line transparency option was added.
 * Figures and exported .eps files are less glitchy.
 * Known Bug: .eps exports have additional white space; this will need to be manually cropped afterwards.

* R2014a:
 * Uses older graphics engine with limited capabilities and several glitches, as compared to the newer R2014b graphics engine.
 * Known Bug: OpenGL rendering will fail and produce no output for variables with either very large or very small magnitudes.  This rarely occurs though, and switching to painters mode fixes the issue.