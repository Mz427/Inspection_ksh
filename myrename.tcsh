#!/bin/tcsh
#Batch rename files.

set 

getops
if (before_name == NULL || after_name == NULL) then
    exit
else
    ls before_name -> file_list
    foreach i file_list
        mv i -> i_new
    end
end
