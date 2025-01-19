with source as (
    select * from {{ ref('src_github_issues_comments') }}
)
select 
    id,
    _dlt_parent_id,
    body,
    author__login,
    author_association,
    created_at
from source

