#!/usr/bin/env python3

import pandas as pd
import sys

def main():
    sample_id = f"{sys.argv[1]}"
    sampleID = [sample_id]

    fpath = f"{sys.argv[2]}"
    absolute_filepath = [fpath]

    manifest =  pd.DataFrame({'sampleID': sampleID, 'absolute-filepath': absolute_filepath})
    manifest = manifest.sort_index(axis=1, ascending=False)
    manifest.to_csv(f"{sample_id}.tsv", sep='\t', index=False, header=True)

main()