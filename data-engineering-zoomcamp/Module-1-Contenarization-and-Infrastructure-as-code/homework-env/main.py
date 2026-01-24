import pandas as pd
from tqdm.auto import tqdm
from sqlalchemy import create_engine
import click
import pyarrow.parquet as pq
import fsspec



@click.command()
@click.option('--user', default='root', help='PostgreSQL user')
@click.option('--password', default='root', help='PostgreSQL password')
@click.option('--host', default='localhost', help='PostgreSQL host')
@click.option('--port', default=5432, type=int, help='PostgreSQL port')
@click.option('--db', default='ny_taxi', help='PostgreSQL database name')
@click.option('--table', default='green_trips_data', help='Target table name')
def ingest_data(user, password, host, port, db, table):
    """Ingest NYC taxi data into PostgreSQL database."""

    url_table = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet"

    url_lookup = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"


    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    batch_size = 10_000

    # Read parquet file from URL_table
    with fsspec.open(url_table, mode="rb") as f:
        pf = pq.ParquetFile(f)

        total_rows = pf.metadata.num_rows
        print(f"Total rows in parquet file: {total_rows}")
        total_batches = (total_rows + batch_size - 1) // batch_size
        print(f"Total batches to process: {total_batches}")

        first = True

        for batch in tqdm(pf.iter_batches(batch_size=batch_size), total=total_batches):
            df_chunk = batch.to_pandas()

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

            print("Inserted Data:", len(df_chunk))

    # Ingest lookup data
    first_lookup = True
    look_up_table = "green_trips_taxi_zone_lookup"

    df_lookup = pd.read_csv(url_lookup)
    # Ingest lookup data
    if first_lookup:
        # Create table schema (no data)
        df_lookup.head(0).to_sql(
            name=look_up_table,
            con=engine,
            if_exists="replace"
        )
        first_lookup = False
        print("Lookup Table created")

    df_lookup.to_sql(
        name=look_up_table,
        con=engine,
        if_exists="append"
    )

    print("Ingestion completed.")


if __name__ == "__main__":
    ingest_data()