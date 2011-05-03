#!/bin/bash
#
# * This program is free software; you can redistribute it and/or
# * modify it under the terms of the GNU General Public License as
# * published by the Free Software Foundation; either version 2 of
# * the License, or (at your option) any later version.#
#
# * By Montes 2010 (www.mooontes.com)

#### Options ###################################

folder="/media/37004FA165097089/tv/"

SERIE[0]="CaMitos"
SERIE[1]="ViajerosVivir"
SERIE[2]="AsturianosEnElMundo"
SERIE[3]="DescubrirElMundo"
SERIE[4]="IanWright"
SERIE[5]="Horizontes"
SERIE[6]="ADesayunar"
SERIE[7]="100veg"
SERIE[8]="CocOrganica"
SERIE[9]="DeChocolate"
SERIE[10]="ParaisosCercanos"
SERIE[11]="CiudadesSiglo21"
SERIE[12]="OrientalYTal"
SERIE[13]="Corcega"
SERIE[14]="TodosALaCosta"
SERIE[15]="DeSidneyATokio"
SERIE[16]="RicoYSano"
SERIE[17]="TopGear"
SERIE[18]="SHEUC"
SERIE[19]="4x20"
SERIE[20]="22min"
SERIE[21]="CocContigo"
SERIE[22]="QueHoy"
SERIE[23]="BloguerosCocineros"
SERIE[24]="PastaGansa"
SERIE[25]="ElMundoEnAccion"
SERIE[26]="LaVeneciaDe"
SERIE[27]="PerryMason"
SERIE[28]="PilotGuides"
SERIE[29]="SanPetersburgo"
SERIE[30]="MexViajeros"
SERIE[31]="NicaViajeros"

CROP[0]="496:423:18:74"
CROP[1]="720:568:0:2"
CROP[2]="720:431:0:76"
CROP[3]="525:560:96:10"
CROP[4]="717:560:2:10"
CROP[5]="717:544:2:16"
CROP[6]="704:571:0:4"
CROP[7]="704:425:0:74"
CROP[8]="702:574:2:2"
CROP[9]="704:427:0:75"
CROP[10]="717:564:2:4"
CROP[11]="709:565:9:5"
CROP[12]="704:425:0:74"
CROP[13]="704:544:8:16"
CROP[14]="529:421:96:76"
CROP[15]="720:560:0:8"
CROP[16]="704:573:0:2"
CROP[17]="496:423:18:74"
CROP[18]="703:571:10:4" #719:573:0:2
CROP[19]="703:574:0:2"
CROP[20]="703:573:0:2"
CROP[21]="704:425:0:74"
CROP[22]="703:573:0:2"
CROP[23]="704:420:0:79"
CROP[24]="695:574:6:2"
CROP[25]="720:576:0:0"
CROP[26]="720:576:0:0"
CROP[27]="697:571:16:2"
CROP[28]="720:576:0:0"
CROP[29]="717:544:2:16"
CROP[30]="544:431:88:72"
CROP[31]="717:555:2:10"

QUAL[0]="1400k"
QUAL[1]="1600k"
QUAL[2]="1600k"
QUAL[3]="1600k"
QUAL[4]="1600k"
QUAL[5]="1600k"
QUAL[6]="1200k"
QUAL[7]="1500k"
QUAL[8]="1400k"
QUAL[9]="1200k"
QUAL[10]="1400k"
QUAL[11]="1600k"
QUAL[12]="1200k"
QUAL[13]="1200k"
QUAL[14]="1600k"
QUAL[15]="1600k"
QUAL[16]="1200k"
QUAL[17]="1200k"
QUAL[18]="1100k"
QUAL[19]="1200k"
QUAL[20]="1200k"
QUAL[21]="1200k"
QUAL[22]="1200k"
QUAL[23]="1200k"
QUAL[24]="1200k"
QUAL[25]="1800k"
QUAL[26]="1800k"
QUAL[27]="1100k"
QUAL[28]="1800k"
QUAL[29]="1800k"
QUAL[30]="1800k"
QUAL[31]="1800k"

##################################################

cont=0

for i in "${SERIE[@]}"
do
    files=$(ls $folder$i*.m2v 2> /dev/null | grep [^*$] -c)
    if [[ $files > 0 ]]; then
        for f in $(ls "$folder$i"*.m2v)
        do
            fich=$(basename "$f")
            ext=$(echo "$fich" | sed 's/^.*\.//')
            name=$(basename "$f" .${ext})
            #echo "Comprimir -$cont- -$name- -$ext- -$fich-"
            mp2=$(ls $folder$name*.mp2 | grep [^*$] -c)
            if [[ $mp2 > 1 ]]; then
	            echo
                echo "- Comprimiendo $name con dos pasos, sonido dual, bitrate de ${QUAL[$cont]} y crop de ${CROP[$cont]} -"
                echo
                ffmpeg -vsync 1 -y -i $folder$name.m2v -an -vcodec libx264 -vpre placebo_firstpass -threads 0 \
                    -deinterlace -b ${QUAL[$cont]} -vf crop=${CROP[$cont]} $folder$name.mp4 -pass 1 \
                    && ffmpeg -vsync 1 -y -i $folder$name.m2v -i $folder$name.mp2 -i "$folder$name"[1].mp2 -ab 48k \
                    -vcodec libx264 -metadata artist="Capturado y comprimido usando Ubuntu" -acodec libfaac -vpre placebo \
                    -threads 0 -deinterlace -b ${QUAL[$cont]} -vf crop=${CROP[$cont]} -alang spa $folder$name.mp4 -alang eng -newaudio -pass 2
            else
                echo
                echo "- Comprimiendo $name con dos pasos, bitrate de ${QUAL[$cont]} y crop de ${CROP[$cont]} -"
                echo
                ffmpeg -vsync 1 -y -i $folder$name.m2v -an -vcodec libx264 -vpre placebo_firstpass -threads 0 \
                    -deinterlace -b ${QUAL[$cont]} -vf crop=${CROP[$cont]} $folder$name.mp4 -pass 1 \
                    && ffmpeg -vsync 1 -y -i $folder$name.m2v -i $folder$name.mp2 -ab 48k -vcodec libx264 -metadata \
                    artist="Capturado y comprimido usando Ubuntu" -acodec libfaac -vpre placebo -threads 0 -deinterlace \
                    -b ${QUAL[$cont]} -vf crop=${CROP[$cont]} $folder$name.mp4 -pass 2
            fi
        done
    fi
    ((cont++))
done

