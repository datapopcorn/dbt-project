with source as (
    select * from {{ source('github_data', 'issues__comments__reactions') }}
)

select * from source