#!/bin/bash

geogebra --v
if [ ! -d export ]
then
	mkdir ./export
	echo "Ordner 'Export' erstellt"
fi

>export_log.txt # Log leeren
#Überprüfung, ob dpi gesetzt sind
if [ -z "$1" ]
then
	dpi=300
else
	dpi=$1
fi
echo "$dpi dpi"
#Dateiformat auswählen
dateiendung=$(zenity --list --width=500 --height=250 --text "Ausgabedateiformat" --title "Dateiformat" --column Dateiendung --column Beschreibung \
pdf			"Dokument" \
png			"Bild" \
svg			"Vektorgrafik" \
emf			"Windows Metafile" \
eps			"Encapsulated PostScript" 2>/dev/null |rev|cut -c -3 |rev)
if [ -z "$dateiendung" ]
then
	echo "kein Dateiformat ausgewählt"
	exit 1
fi
# Konvertieren
for x in *.ggb; do 
	name=$(basename $x .ggb)
	ausgabedatei="./export/$name.$dateiendung"
	echo "$x (.$dateiendung)"
	if [ ! -f "$ausgabedatei" ]
	then
		if ! grep -Fq "$name" export_ignore.txt 
		then
			geogebra --export=$ausgabedatei --dpi=$dpi --showAlgebraInput=false --showAlgebraWindow=false --showSpreadsheet=false --showCAS=false --versionCheckAllow=false $x >> export_log.txt 2>&1
			echo "$x fertig"
			echo ""
			sleep 1
		else
			echo "$x ignoriert"
			echo ""
		fi
	else
		echo "$x wurde schon konvertiert ($ausgabedatei)"
		echo ""
	fi
done
