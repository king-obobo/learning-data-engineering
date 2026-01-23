import pandas as pd
from tqdm.auto import tqdm
from sqlalchemy import create_engine
import click


dtype = {
    "VendorID": "Int64",
    "passenger_count": "Int64",
    "trip_distance": "float64",
    "RatecodeID": "Int64",
    "store_and_fwd_flag": "string",
    "PULocationID": "Int64",
    "DOLocationID": "Int64",
    "payment_type": "Int64",
    "fare_amount": "float64",
    "extra": "float64",
    "mta_tax": "float64",
    "tip_amount": "float64",
    "tolls_amount": "float64",
    "improvement_surcharge": "float64",
    "total_amount": "float64",
    "congestion_surcharge": "float64"
}

parse_dates = [
    "tpep_pickup_datetime",
    "tpep_dropoff_datetime"
]




@click.command()
@click.option('--user', default='root', help='PostgreSQL user')
@click.option('--password', default='root', help='PostgreSQL password')
@click.option('--host', default='localhost', help='PostgreSQL host')
@click.option('--port', default=5432, type=int, help='PostgreSQL port')
@click.option('--db', default='ny_taxi', help='PostgreSQL database name')
@click.option('--table', default='yellow_taxi_data_ingest_data_script', help='Target table name')
@click.option('--year', default='2021', help='Target Year of data to ingest')
@click.option('--month', default='01', help='Target Month of data to ingest')
def ingest_data(user, password, host, port, db, table, year, month):
    """Ingest NYC taxi data into PostgreSQL database."""

    prefix = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_"

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df_iter = pd.read_csv(
        prefix + f'{year}-{month}.csv.gz',
        dtype=dtype,
        parse_dates=parse_dates,
        iterator=True,
        chunksize=100000
    )


    first = True

    for df_chunk in tqdm(df_iter):

        if first:
            # Create table schema (no data)
            df_chunk.head(0).to_sql(
                name=table,
                con=engine,
                if_exists="replace"
            )
            first = False
            print("Table created")

        # Insert chunk
        df_chunk.to_sql(
            name=table,
            con=engine,
            if_exists="append"
        )

        print("Inserted:", len(df_chunk))

    print("Ingestion completed.")


if __name__ == "__main__":
    ingest_data()