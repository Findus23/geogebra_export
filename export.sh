#!/bin/bash
dateiendung=$(zenity --list --width=500 --height=250 --text "Ausgabedateiformat" --title "Dateiformat" --column Dateiendung --column Beschreibung \
pdf			"Dokument" \
png			"Bild" \
svg			"Vektorgrafik" \
emf			"Windows Metafile" \
eps			"Encapsulated PostScript"|rev|cut -c -3 |rev)
for x in *.ggb; do 
	name=$(echo $x |rev | cut -c 5- |rev)
	ausgabedatei="./export/$name.$dateiendung"
	echo "-----$ausgabedatei---------"
	if [ ! -f "$ausgabedatei" ]
	then
		if ! grep -Fq "$name" export_ignore.txt 
		then
			geogebra --export=$ausgabedatei --dpi=300 --showAlgebraInput=false --showAlgebraWindow=false --showSpreadsheet=false --showCAS=false $x
			sleep 3
		fi
	fi
done
