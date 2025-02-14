#!/usr/bin/env python3

import pandas as pd
import sys

def main():
    fpath = f"{sys.argv[1]}"

    df = pd.read_csv(fpath)
    df["mean_shannon"] = df.iloc[:, 1:].mean(axis=1)
    df["rate_of_change"] = df["mean_shannon"].diff()

    plateau = df.loc[df["rate_of_change"].abs() < 0.01, "depth"].min()
    print(plateau)

main()