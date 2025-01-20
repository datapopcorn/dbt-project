with source as (
    select * from {{ ref('src_github_issues_reactions') }}
)

select 
    user__login as reaction_user,
    content as reaction_content,
    created_at as reaction_created_at,
    _dlt_id as reaction_id,
    _dlt_parent_id as issue_id
from source