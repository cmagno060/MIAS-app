#!/bin/bash

# convert black.png mdb$ID.png mdb$IDmask.png -composite mdb$IDcleaned.png

cd fondo/
convert -size 1024x1024 xc:black black.png
end1="mask.png"
end2="cleaned.png"
for i in $(seq 1 1 322)
do
	if [ $i -lt 10 ]
	then
		idMam="mdb00$i"
	else
		if [ $i -lt 100 ]
		then
			idMam="mdb0$i"
		else
			idMam="mdb$i"
		fi
	fi
	originalfile="../all-mias/$idMam.png"
	maskfile="$idMam$end1"
	cleanedfile="$idMam$end2"
	convert black.png $originalfile $maskfile -composite $cleanedfile
	echo "File $cleanedfile created successfully"
done
rm black.png
