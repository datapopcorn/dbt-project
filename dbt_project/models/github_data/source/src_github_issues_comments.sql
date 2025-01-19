with source as (
    select * from {{ source('github_data', 'issues__comments') }}
)
select * from source
