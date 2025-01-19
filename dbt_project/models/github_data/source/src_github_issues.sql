with source as (
      select * from {{ source('github_data', 'issues') }}
)
select * from source
