import sys
from awsglue.context import GlueContext
from pyspark.context import SparkContext

glueContext = GlueContext(SparkContext.getOrCreate())

datasource = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": ["s3://vital-health-migration/"]},
    format="csv",
    format_options={"withHeader": True}
)

parquet_output = "s3://vital-health-migration/parquet/"
glueContext.write_dynamic_frame.from_options(
    frame=datasource,
    connection_type="s3",
    connection_options={"path": parquet_output},
    format="parquet"
)
