mkdir -p data
mkdir -p results

cd results

mkdir -p 01-make-manifest
mkdir -p 02-make-artifact
mkdir -p 03-infer-asv
mkdir -p 04-filter-features
mkdir -p 05-filter-rep-seqs
mkdir -p 06-assign-taxa
mkdir -p 07-make-bar-plot
mkdir -p 08-merge-rep-seqs
mkdir -p 09-make-phylogeny
mkdir -p 10-merge-table
mkdir -p 11-make-rarefaction-curve
mkdir -p 12-export-rarefaction-curve
mkdir -p 13-calculate-plateau
mkdir -p 14-rarefy

if ! [ -L 17-merge-rarefied-table ] ; then
    ln -s 10-merge-table 17-merge-rarefied-table
fi


cd ..