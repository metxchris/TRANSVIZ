netcdfobj (http://www.mathworks.com/matlabcentral/fileexchange/31615-netcdfobj-netcdf-made-easy/content/netcdfvar.m) 
provides a fast method to view NETCDF files.  However, only one element may be accessed at a time, so this method has 
not been used in TRANSVIZ.

ex usage: 	
```python
filePath = 'C:\Users\MetxChris\Documents\MATLAB\101391T25.CDF';
			obj=netcdfobj(filePath);
```
			
MATLAB NETCDF Commands:
```python
ncid = netcdf.open(filePath,'NC_NOWRITE'); % open CDF for reading
finfo = ncinfo(filePath); % stores all file info (other than values of each variable)
varid = netcdf.inqVarID(ncid,'NE'); % inquery ID of variable 'NE'
vardata = netcdf.getVar(ncid, varid); % store data of variable referenced by varid
```