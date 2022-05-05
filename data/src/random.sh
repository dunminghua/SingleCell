#!/bin/bash
source /lanec3_home/huadm/SingleCell/src/config

# - to _
Cortical_L2_5_Pyramidal_Cell=$dirData/hicfile/Cortical_L2–5_Pyramidal_Cell
Cortical_L6_Pyramidal_Cell=$dirData/hicfile/Cortical_L6_Pyramidal_Cell
Hippocampal_Granule_Cell=$dirData/hicfile/Hippocampal_Granule_Cell
Hippocampal_Pyramidal_Cell=$dirData/hicfile/Hippocampal_Pyramidal_Cell
Interneuron=$dirData/hicfile/Interneuron
Medium_Spiny_Neuron=$dirData/hicfile/Medium_Spiny_Neuron
Microglia_Etc=$dirData/hicfile/Microglia_Etc
Neonatal_Astrocyte=$dirData/hicfile/Neonatal_Astrocyte
neonatal_neuron_1=$dirData/hicfile/Neonatal_Neuron_1
Neonatal_Neuron_2=$dirData/hicfile/Neonatal_Neuron_2
Oligodendrocyte_Progenitor=$dirData/hicfile/Oligodendrocyte_Progenitor
Unknown=$dirData/hicfile/Unknown
Mature_Oligodendrocyte=$dirData/hicfile/Mature_Oligodendrocyte

Neuron=$dirData/hicfile/Neuron/cortex/
Oligo=$dirData/hicfile/Oligo/
Astrocyte=$dirData/hicfile/Astrocyte/

Neuron_vs_oligo=$dirData/repeat_10_time_filelist/Neuron_vs_Oligo/
Neuron_vs_oligo_contact=$dirData/repeat_10_time_filelist/Neuron_vs_Oligo_Mat/

cell=(cell_20 cell_50 cell_100 cell_150 cell_200 cell_250 cell_300 cell_350 cell_400 cell_450 cell_500)

############################2022-5-3##########################################
############################Add sparse matrix#################################
function merged {
    condition1=/lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Neuron
    condition2=/lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Oligo

    $python3 src/add_sparse_mat.py /lanec3_home/huadm/SingleCell/data/repeat_10_time_filelist/Neuron_vs_Oligo_Mat/$1 $condition1 $condition2 /lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Neuron_vs_Oligo_merged
}

#$python3 src/add_sparse_mat.py /lanec3_home/huadm/SingleCell/data/repeat_10_time_filelist/Neuron_vs_Oligo_Mat/$c $condition1 $condition2 /lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Neuron_vs_Oligo_merged &
merged ${cell[0]} &
merged ${cell[1]} &
merged ${cell[2]} &
merged ${cell[3]} &
merged ${cell[4]} &
merged ${cell[5]} &
merged ${cell[6]} &
merged ${cell[7]} &
merged ${cell[8]} &
merged ${cell[9]} &
merged ${cell[10]} &
wait
exit

############################Add sparse matrix#################################
############################2022-5-2##########################################
#random_single_cell.py
function generatePairFile {
    Neuron_sparseMat=/lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Neuron/
    Oligo_sparseMat=/lanec3_home/huadm/SingleCell/data/temp_data/sparseMat/Oligo/

    #$python3 src/random_single_cell.py $Neuron $Oligo $1 $2 $Neuron_vs_oligo/$3 Neuron Oligo
    $python3 src/random_single_cell.py $Neuron_sparseMat $Oligo_sparseMat $1 $2 $Neuron_vs_oligo_contact/$3 Neuron Oligo
}

generatePairFile 20 20 cell_20
generatePairFile 50 50 cell_50
generatePairFile 100 100 cell_100
generatePairFile 150 150 cell_150
generatePairFile 200 200 cell_200
generatePairFile 250 250 cell_250
generatePairFile 300 250 cell_300
generatePairFile 350 250 cell_350
generatePairFile 400 250 cell_400
generatePairFile 450 250 cell_450
generatePairFile 500 250 cell_500
exit
############################2022-5-2##########################################



############################2022-5-3##########################################
function dump2 {
#for i in 1 X
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 X
do
    outputdir=$2
    if [ -d "$outputdir" ]; then
        echo "'$outputdir' is existing."
    else
        mkdir -p $outputdir
    fi
    echo $1
    java -jar juicer_tools_1.22.01.jar dump observed NONE $1 $i $i BP 50000 $outputdir/chr${i}.txt

done
}

#function pre_dump2 {
#for file in `ls $1`
#do
#    echo $1$file
#    name="${file%.*}"
#    dir_name=$2$name
#    echo $dir_name
#    dump2 $1$file $dir_name
#done
#}

function pre_dump2 {
while read line1; read line2;read line3; read line4; read line5; read line6; read line7; read line8; read line9; read line10
do
    #echo `echo $2${line1##*/} | "${fullname%.*}"`
    #echo $2`echo $(basename $line1) | cut -d . -f1`.contacts
    dump2 $line1 $2`echo $(basename $line1) | cut -d . -f1`.contacts &
    dump2 $line2 $2`echo $(basename $line2) | cut -d . -f1`.contacts &
    dump2 $line3 $2`echo $(basename $line3) | cut -d . -f1`.contacts &
    dump2 $line4 $2`echo $(basename $line4) | cut -d . -f1`.contacts &
    dump2 $line5 $2`echo $(basename $line5) | cut -d . -f1`.contacts &
    dump2 $line6 $2`echo $(basename $line6) | cut -d . -f1`.contacts &
    dump2 $line7 $2`echo $(basename $line7) | cut -d . -f1`.contacts &
    dump2 $line8 $2`echo $(basename $line8) | cut -d . -f1`.contacts &
    dump2 $line9 $2`echo $(basename $line9) | cut -d . -f1`.contacts &
    dump2 $line10 $2`echo $(basename $line10) | cut -d . -f1`.contacts &
    wait
done < $1
}

#pre_dump2 $dirData/hicfile/Oligo/ $dirData/temp_data/sparseMat/Oligo/ >>$dirLog/process_sparsemat-log

#filepath=`ls $dirData/hicfile/Neuron/cortex/`
#pre_dump2 log/Neuron-filelist-log $dirData/temp_data/sparseMat/Neuron/ >>$dirLog/process_sparsemat-log
#exit

############################2022-5-3##########################################
############################2022-5-2##########################################
function dump {
count=0
#record cell number
while read line;
do
    count=$[count+1]
    echo "processing for $line"
    #for i in 1 X
    for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 X
    do
        outputdir=$2/cell_$count
        if [ -d "$outputdir" ]; then
            echo "'$outputdir' is existing."
        else
            mkdir -p $outputdir
        fi
        java -jar juicer_tools_1.22.01.jar dump observed NONE $line $i $i BP 50000 $outputdir/chr${i}.txt

    done
done < $1
}

function pre_dump {
DIR=$2
if [ -d "$DIR" ]; then
    echo "'$DIR' is existing, please wait ..."
else
    mkdir -p $DIR
    echo "'$DIR' has made."
fi

for file in `ls $1`
do
    echo $1$file
    name="${file%.*}"
    dir_name=$2$name
    echo $dir_name
    dump $1$file $dir_name &
done
}

#dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_20/
#
#pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_20/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_20/ >>$dirLog/process_sparsemat-log


pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_50/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_50/ >>$dirLog/process_sparsemat-log
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_100/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_100/ >>$dirLog/process_sparsemat-log
wait
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_150/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_150/ >>$dirLog/process_sparsemat-log
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_200/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_200/ >>$dirLog/process_sparsemat-log
wait
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_250/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_250/ >>$dirLog/process_sparsemat-log
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_300/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_300/ >>$dirLog/process_sparsemat-log
wait
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_350/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_350/ >>$dirLog/process_sparsemat-log
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_400/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_400/ >>$dirLog/process_sparsemat-log
wait
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_450/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_450/ >>$dirLog/process_sparsemat-log
pre_dump $dirData/repeat_10_time_filelist/Neuron_vs_Oligo/cell_500/ $dirData/temp_data/Neuron_vs_Oligo/sparseMat/cell_500/ >>$dirLog/process_sparsemat-log
wait
exit




