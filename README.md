# tutR
R scripts to support the personal tutorial system

## Tutorial attendance

[tutattend.R](tutattend.R) - Does the following, using data drawn from the tutorial attendance monitoring system.

1. Determines pass/fail on tutorial attendance for each student,

2. Calculates mean attendance by module, 

3. Calculates number of missing data points (by tutor). 

4. Checks accuracy of a pass/fail list generated by other means (Excel).

5. Creates visualization of tutorial attendace for each tutor, with tutorial (1-10) on the x-axis, tutor on the y-axis, size of circle proportional to total number of tutees (at 100% attendance). Colour of circle indicates attendance rate (green: high attendance, red: low attendance). 

**NOTE:** Data files are _not_ included in this repository because the files contains _non-anonymized_ data. A copy of the relevant CSV files were sent to the Psychology Staff mailing list -- save these into your RStudio project directory.

