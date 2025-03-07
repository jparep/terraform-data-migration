import sys
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from pyspark.sql import SparkSession

# Initialize Spark session with optimized configurations
spark = (SparkSession.builder
    .config("spark.sql.shuffle.partitions", "200")  # Adjust based on data size
    .config("spark.default.parallelism", "100")     # Optimize parallelism
    .getOrCreate())

glueContext = GlueContext(spark.sparkContext)

# Define S3 paths as constants
INPUT_PATH = "s3://vital-health-migration/"
OUTPUT_PATH = "s3://vital-health-migration/parquet/"

try:
    # Create dynamic frame with optimized CSV reading options
    datasource = glueContext.create_dynamic_frame.from_options(
        connection_type="s3",
        connection_options={
            "paths": [INPUT_PATH],
            "recurse": True  # Enable recursive file lookup if needed
        },
        format="csv",
        format_options={
            "withHeader": True,
            "optimizePerformance": True,  # Enable performance optimization
            "quoteChar": '"',             # Specify quote character
            "separator": ","              # Explicitly define separator
        }
    )

    # Write to Parquet with partitioning and compression
    glueContext.write_dynamic_frame.from_options(
        frame=datasource,
        connection_type="s3",
        connection_options={
            "path": OUTPUT_PATH,
            "partitionKeys": []  # Add partition columns if needed
        },
        format="parquet",
        format_options={
            "compression": "snappy"  # Use Snappy compression for better performance
        }
    )

except Exception as e:
    print(f"Error processing data: {str(e)}")
    raise

finally:
    # Clean up resources
    spark.stop()