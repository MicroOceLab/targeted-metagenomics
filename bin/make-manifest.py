#!/usr/bin/env python3

import pandas as pd
import sys

def main():
    cwd = f"{sys.argv[1]}/data/"
    fpath = f"{cwd}{sys.argv[2]}"
    sample = fpath.split("/")[-1].rsplit("-", 2)[0]

    sampleIDs = [sample]
    abs_path = [fpath]

    manifest =  pd.DataFrame({'sampleID': sampleIDs, 'absolute-filepath': abs_path})
    manifest = manifest.sort_index(axis=1, ascending=False)
    manifest.to_csv(f"{sample.split('.')[0]}.tsv", sep='\t', index=False, header=True)

main()