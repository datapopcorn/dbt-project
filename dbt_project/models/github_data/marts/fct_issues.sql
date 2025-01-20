{{ config(materialized='table') }}
with issues as (
    select 
        issue_id,
        issue_number,
        issue_title,
        issue_body,
        issue_author,
        issue_author_association,
        reactions_total_count,
        comments_total_count,
        issue_created_at,
        issue_closed_at,
        issue_updated_at
     from {{ ref('stg_github_issues') }}
)

select * from issues