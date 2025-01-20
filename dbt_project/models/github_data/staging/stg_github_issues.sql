with source as (
    select * from {{ ref('src_github_issues') }}
)
select 
    number as issue_number,
    _dlt_id as issue_id,
    title as issue_title,
    body as issue_body,
    author__login as issue_author,
    author_association as issue_author_association,
    reactions_total_count,
    comments_total_count,
    created_at as issue_created_at,
    closed_at as issue_closed_at,
    updated_at as issue_updated_at
from source

