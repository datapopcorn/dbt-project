with source as (
    select * from {{ source('github_data', 'issues__reactions') }}
)

select * from source