with source as (
    select * from {{ ref('src_github_issues_comments') }}
)
select 
    _dlt_id as comment_id,
    _dlt_parent_id as issue_id,
    body as comment_body,
    author__login as comment_author,
    author_association as comment_author_association,
    created_at as comment_created_at,
from source

