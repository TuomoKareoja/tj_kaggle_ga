import os
import json
from pandas.io.json import json_normalize
import pandas as pd


def read_csv_and_flatten_json(input_filepath):
    JSON_COLUMNS = ["device", "geoNetwork", "totals", "trafficSource"]

    df = pd.read_csv(
        input_filepath,
        converters={column: json.loads for column in JSON_COLUMNS},
        dtype={"fullVisitorId": "str"},  # Important!!
        nrows=None,
    )

    for column in JSON_COLUMNS:
        column_as_df = json_normalize(df[column])
        column_as_df.columns = [
            f"{column}.{subcolumn}" for subcolumn in column_as_df.columns
        ]
        df = df.drop(column, axis=1).merge(
            column_as_df, right_index=True, left_index=True
        )
    return df

