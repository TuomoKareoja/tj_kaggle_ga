"""
.. module:: make_dataset.py
    :synopsis:
"""

import click
import logging
from pathlib import Path
from dotenv import find_dotenv, load_dotenv
import os
from src.data.data_processing import read_csv_and_flatten_json


@click.command()
def main():
    """ Runs data processing scripts to turn raw data from (../raw) into
        cleaned data ready to be analyzed (saved in ../processed).
    """
    raw_path = os.path.abspath(os.getcwd() + "/data/raw/")
    interim_path = os.path.abspath(os.getcwd() + "/data/interim/")
    processed_path = os.path.abspath(os.getcwd() + "/data/processed/")

    logger = logging.getLogger(__name__)
    logger.info("making final data set from raw data")
    for file in ["train.csv", "test.csv"]:
        print("reading " + file + " from " + raw_path)
        df = read_csv_and_flatten_json(os.path.join(raw_path, file))
        df.name = file[:-4] + "_flattened.pkl"
        print("saving " + df.name + " to " + interim_path)
        df.to_csv(os.path.join(interim_path, df.name))


if __name__ == "__main__":
    log_fmt = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    logging.basicConfig(level=logging.INFO, format=log_fmt)

    # not used in this stub but often useful for finding various files
    project_dir = Path(__file__).resolve().parents[2]

    # find .env automagically by walking up directories until it's found, then
    # load up the .env entries as environment variables
    load_dotenv(find_dotenv())

    main()

