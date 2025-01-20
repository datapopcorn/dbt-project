{{ config(materialized='table') }}
with comments as (
    select 
        comment_id,
        issue_id,
        comment_body,
        comment_author,
        comment_author_association,
        comment_created_at
     from {{ ref('stg_github_issues_comments') }}
)

select * from comments