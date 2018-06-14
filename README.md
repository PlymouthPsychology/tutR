# tutR
R scripts to support the personal tutorial system

## Tutorial attendance

[tutattend.R](tutattend.R) - Determines pass/fail on tutorial attendance for each student, using data drawn from tutorial attendance monitoring system. Also calculates mean attendance by module, and number of missing data points (by tutor). 

A data file is **not** included in this repository because the file contains _non-anonymized_ data. A copy of the relevant CSV file will be sent to the Psychology Staff mailing list -- save that copy into your RStudio tutR project directory.

One of the interesting things about this script is that it illustrates one of the advantages on the "long" data format used by R. In the wide data format produced by the attendance monitoring system, the entry "NULL" has two different meanings: (a) The tutor did not enter some data, (b) This tutorial did not occur for this Stage (i.e. Tutorials 8-10 for Stages 2 & 4). For the purposes of analysis it is important to distinguish these two meanings. In long format, it is trivial to do so, because you don't have entries for non-real tutorials!

