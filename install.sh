mkdir -p data
mkdir -p results

cd results

mkdir -p 01-make-manifest
mkdir -p 02-make-artifact
mkdir -p 03-infer-asv
mkdir -p 04-merge-rep-seqs
mkdir -p 05-make-phylogeny
mkdir -p 06-filter-features
mkdir -p 07-merge-table
mkdir -p 08-make-rarefaction-curve
mkdir -p 09-export-rarefaction-curve
mkdir -p 10-calculate-plateau
mkdir -p 11-rarefy

if ! [ -L 12-merge-rarefied-table ] ; then
    ln -s 07-merge-table 12-merge-rarefied-table
fi

mkdir -p 13-filter-rep-seqs
mkdir -p 14-assign-taxa
mkdir -p 15-make-bar-plot
cd ..