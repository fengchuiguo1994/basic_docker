sample=$1

awk '{print $1"\t0\t"$2"\tp36.33\tgneg"}' genome/$sample/$sample.fa.fai > genome/$sample/$sample.cytoBand.txt
cut -f 1-2 genome/$sample/$sample.fa.fai > genome/$sample/$sample.txt

cp genome/$sample/$sample.txt BASIC/gis-basic-storage/data/genome/size/
cp genome/$sample/$sample.txt BASIC/basic3/browser/genome/size/
cp genome/$sample/$sample.cytoBand.txt BASIC/gis-basic-storage/data/genome/chrband/$sample.txt
mkdir -p genome/$sample/extract_seq
perl split.pl genome/$sample/$sample.fa genome/$sample/extract_seq/
python BASIC/gis-basic-storage/driver/customds/acgt/build_acgt.new.py $sample genome/$sample/$sample.txt -i genome/$sample/extract_seq/ -o genome/$sample/$sample -p 8
cp -r genome/$sample/$sample BASIC/gis-basic-storage/data/genome/acgt/
cp -r genome/$sample/$sample data/acgt/

