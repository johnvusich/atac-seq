module load UCSC_Tools/19.4.2024-linux-x86_64

for bw in /mnt/home/path/to/bigwig_files/*.bigWig; do
    base=$(basename ${bw} .bigWig)
    bigWigToBedGraph ${bw} /mnt/home/path/to/bigwig_files/${base}.bedGraph
done
