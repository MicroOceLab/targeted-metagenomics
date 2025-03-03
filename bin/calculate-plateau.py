#!/usr/bin/env python3

import pandas as pd
import sys

def main():
    # prepare DataFrame from CSV
    fpath = f"{sys.argv[1]}"
    df = pd.read_csv(fpath).drop("sample-id", axis=1)
    
    # merge columns with the same depth
    df = merge_iterations(df)
    
    # drop columns with 0 OTUs
    df = drop_zero_otus(df)

    # get pd.Series of depth
    depth_list = get_depth_list(df)

    # get pd.Series of mean
    mean_list = get_mean_list(df)

    # get depth at plateau
    plateau = get_plateau(depth_list, mean_list)
    print(plateau)


def get_depth(column):
    return column.split("_")[0].split("-")[1]


def merge_columns(df, depth,  merge_list):
    df_temp = pd.DataFrame()
    df_temp[f"depth-{depth}_iter-0"] = df[merge_list[0]]

    for column in merge_list[1:]:
        df_temp[f"depth-{depth}_iter-0"] += df[column]
    
    df_temp[f"depth-{depth}_iter-0"] = df_temp[f"depth-{depth}_iter-0"] / 10.0 
    return df_temp


def merge_iterations(df):
    depth_previous = -1
    merge_list = []
    df_temp = pd.DataFrame()

    for column, values in df.items():
        depth = int(get_depth(column))
        if depth_previous != -1 and depth != depth_previous:
            df_column = merge_columns(df, depth_previous, merge_list)
            df_temp = pd.concat([df_temp, df_column], axis=1)
            merge_list = []
        merge_list.append(column)
        depth_previous = depth

    df_column = merge_columns(df, depth, merge_list)
    df_temp = pd.concat([df_temp, df_column], axis=1)

    return df_temp


def drop_zero_otus(df):
    drop_list = []

    for column, values in df.items():
        if 0 not in map(int, values.to_list()):
            break
        drop_list.append(column)

    df = df.drop(drop_list, axis=1)

    return df


def get_depth_list(df):
    ls = []

    for column, values in df.items():
        ls.append(get_depth(column))

    return ls


def get_mean_list(df):
    return df.mean().to_list()


def get_plateau(depth_list, mean_list):
    df = pd.DataFrame(data={"depth": depth_list, "mean": mean_list})
    df["diff"] = df["mean"] - df["mean"].shift(1)
    df_plateau = df[df["diff"] < 0.01]
    plateau = df["depth"].iloc[-1] if df_plateau.empty else df_plateau["depth"].iloc[0]

    return plateau


main()