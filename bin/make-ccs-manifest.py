#!/usr/bin/env python3

import pandas as pd
import sys

def main():
    fpath = f"{sys.argv[1]}"
    sample = fpath.split("/")[-1]

    sampleIDs = [sample]
    abs_path = [fpath]

    manifest =  pd.DataFrame({'sampleID': sampleIDs, 'absolute-filepath': abs_path})
    manifest = manifest.sort_index(axis=1, ascending=False)
    manifest.to_csv(f"{sample.split('.')[0]}.tsv", sep='\t', index=False, header=True)

main()