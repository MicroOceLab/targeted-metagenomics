#!/usr/bin/env python3

import pandas as pd
import sys

def main():
    fpath = f"{sys.argv[1]}"
    sample = fpath.split("/")[-1]

    if "_" in sample:
        sample_id = sample.rsplit("_", 2)[0]
    elif "-" in sample:
        sample_id = sample.rsplit("-", 2)[0]
    else:
        sample_id = sample
    
    print(sample_id)

main()