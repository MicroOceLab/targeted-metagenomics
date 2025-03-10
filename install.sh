mkdir -p data
mkdir -p results

cd results

mkdir -p 01-make-manifest
mkdir -p 02-make-artifact
mkdir -p 03-infer-asv
mkdir -p 04-merge-rep-seqs
mkdir -p 05-make-phylogeny
mkdir -p 06-merge-table
mkdir -p 07-make-rarefaction-curve
mkdir -p 08-export-rarefaction-curve
mkdir -p 09-calculate-plateau
mkdir -p 10-rarefy

if ! [ -L 11-merge-rarefied-table ] ; then
    ln -s 06-merge-table 11-merge-rarefied-table
fi

mkdir -p 12-filter-rep-seqs
mkdir -p 13-assign-taxa
mkdir -p 14-make-bar-plot
cd ..