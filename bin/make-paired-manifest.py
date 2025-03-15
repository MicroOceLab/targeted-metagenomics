#!/usr/bin/env python3

import pandas as pd
import sys

def main():
    sample_id = f"{sys.argv[1]}"
    sampleID = [sample_id]

    forward_fpath = f"{sys.argv[2]}"
    forward_absolute_filepath = [forward_fpath]

    reverse_fpath = f"{sys.argv[3]}"
    reverse_absolute_filepath = [reverse_fpath]

    manifest =  pd.DataFrame({'sampleID': sampleID, 'forward-absolute-filepath': forward_absolute_filepath, 'reverse-absolute-filepath': reverse_absolute_filepath})
    manifest = manifest.sort_index(axis=1, ascending=False)
    manifest.to_csv(f"{sample_id}.tsv", sep='\t', index=False, header=True)

main()