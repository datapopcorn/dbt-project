with source as (
    select * from {{ ref('src_github_issues') }}
)
select 
    number,
    _dlt_id,
    title,
    body,
    author__login,
    author_association,
    reactions_total_count,
    comments_total_count,
    created_at,
    closed_at,
    updated_at
from source
