cp -r data/hicfile/Cortical_L2_5_Pyramidal_Cell/* data/hicfile/Neuron
exit
cp -r data/hicfile/Neonatal_Neuron_1/* data/hicfile/Neuron
cp -r data/hicfile/Neonatal_Neuron_2/* data/hicfile/Neuron
cp -r data/hicfile/Cortical_L6_Pyramidal_Cell/* data/hicfile/Neuron
cp -r data/hicfile/Hippocampal_Granule_Cell/* data/hicfile/Neuron
cp -r data/hicfile/Hippocampal_Pyramidal_Cell/* data/hicfile/Neuron
cp -r data/hicfile/Interneuron/* data/hicfile/Neuron
cp -r data/hicfile/Medium_Spiny_Neuron/* data/hicfile/Neuron
exit


function mvFile {
mkdir $2
while read line;
do
    #mv $line
    #echo $line
    cellID=`echo $line | awk '{print $1}'`
    echo $cellID
    mv hicfile/*${cellID}* $2
done < $1
}

#mvFile cell_type_ID/Adult_Astrocyte.txt hicfile/Adult_Astrocyte
mvFile cell_type_ID/Cortical_L2–5_Pyramidal_Cell.txt hicfile/Cortical_L2–5_Pyramidal_Cell
mvFile cell_type_ID/Cortical_L6_Pyramidal_Cell.txt hicfile/Cortical_L6_Pyramidal_Cell
mvFile cell_type_ID/Hippocampal_Granule_Cell.txt hicfile/Hippocampal_Granule_Cell
mvFile cell_type_ID/Hippocampal_Pyramidal_Cell.txt hicfile/Hippocampal_Pyramidal_Cell
mvFile cell_type_ID/Interneuron.txt hicfile/Interneuron
mvFile cell_type_ID/Mature_Oligodendrocyte.txt hicfile/Mature_Oligodendrocyte
mvFile cell_type_ID/Medium_Spiny_Neuron.txt hicfile/Medium_Spiny_Neuron
mvFile cell_type_ID/Microglia_Etc..txt hicfile/Microglia_Etc
mvFile cell_type_ID/Neonatal_Astrocyte.txt hicfile/Neonatal_Astrocyte
mvFile cell_type_ID/Neonatal_Neuron_1.txt hicfile/Neonatal_Neuron_1
mvFile cell_type_ID/Neonatal_Neuron_2.txt hicfile/Neonatal_Neuron_2
mvFile cell_type_ID/Oligodendrocyte_Progenitor.txt hicfile/Oligodendrocyte_Progenitor
mvFile cell_type_ID/Unknown.txt hicfile/Unknown
exit
