with source as (
      select * from {{ source('test_schema', 'ga4_iceberg') }}
)

select * from source