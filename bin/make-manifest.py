#!/usr/bin/env python3

import pandas as pd
import sys

def main():
    fpath= f"{sys.argv[1]}"
    sample = fpath.split("/")[-1].rsplit("-", 2)[0]

    sampleIDs = [sample]
    abs_path = [fpath]

    manifest =  pd.DataFrame({'sampleID': sorted(sampleIDs), 'absolute-filepath': sorted(abs_path)}) 
    with open(f"{sample.split('.')[0]}.txt", 'w+') as m:
        print(manifest.to_csv(sep='\t', index=False, header=True), file=m)

main()