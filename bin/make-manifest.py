import pandas as pd
import os
import sys

def main():
    fpath= f"{os.getcwd()}/data/{sys.argv[1]}"
    sample = fpath.split("/")[-1].rsplit("-", 2)[0]

    sampleIDs = [sample]
    abs_path = [fpath]

    manifest =  pd.DataFrame({'sampleID': sorted(sampleIDs), 'absolute-filepath': sorted(abs_path)}) 
    with open(f"results/1-data-prep/{sample}.txt", 'w') as m:
        print(manifest.to_csv(sep='\t', index=False, header=True), file=m)

main()