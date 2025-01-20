{{ config(materialized='table') }}
with issues as (
    select 
        issue_id,
        issue_number,
        issue_title,
        issue_body,
        issue_author,
        issue_author_association,
        issue_created_at,
        issue_closed_at,
        issue_updated_at
    from {{ ref('stg_github_issues') }}
),

comments as (
    select 
        comment_id,
        issue_id,
        comment_body,
        comment_author,
        comment_author_association,
        comment_created_at
    from {{ ref('stg_github_issues_comments') }}
),

issues_reactions as (
    select 
        issue_id,
        reaction_id,
        reaction_user,
        reaction_content,
        reaction_created_at
    from {{ ref('stg_github_issues_reactions') }}
),

comments_reactions as (
    select 
        comment_id,
        reaction_id,
        reaction_user,
        reaction_content,
        reaction_created_at
    from {{ ref('stg_github_issues_comments_reactions') }}
),

issues_join_reactions as (
    select 
        issues.issue_id,
        issues.issue_number,
        issues.issue_title,
        issues.issue_body,
        issues.issue_author,
        issues.issue_author_association,
        issues.issue_created_at,
        issues.issue_closed_at,
        issues.issue_updated_at,
        issues_reactions.reaction_id,
        issues_reactions.reaction_user,
        issues_reactions.reaction_content,
        issues_reactions.reaction_created_at
    from issues
    left join issues_reactions on issues.issue_id = issues_reactions.issue_id
),

comments_join_reactions as (
    select 
        comments.comment_id,
        comments.issue_id,
        comments.comment_body,
        comments.comment_author,
        comments.comment_author_association,
        comments.comment_created_at,
        comments_reactions.reaction_id,
        comments_reactions.reaction_user,
        comments_reactions.reaction_content,
        comments_reactions.reaction_created_at
    from comments
    left join comments_reactions on comments.comment_id = comments_reactions.comment_id
)

select
    issue_id,
    issue_number,
    issue_title,
    issue_body,
    issue_author,
    issue_author_association,
    issue_created_at,
    issue_closed_at,
    issue_updated_at,
    null as comment_id,
    null as comment_body,
    null as comment_author,
    null as comment_author_association,
    null as comment_created_at,
    reaction_id,
    reaction_user,
    reaction_content,
    reaction_created_at
from issues_join_reactions
union all
select
    cr.issue_id,
    issues.issue_number,
    issues.issue_title,
    issues.issue_body,
    issues.issue_author,
    issues.issue_author_association,
    issues.issue_created_at,
    issues.issue_closed_at,
    issues.issue_updated_at,
    cr.comment_id,
    cr.comment_body,
    cr.comment_author,
    cr.comment_author_association,
    cr.comment_created_at,
    cr.reaction_id,
    cr.reaction_user,
    cr.reaction_content,
    cr.reaction_created_at
from comments_join_reactions cr
join issues on cr.issue_id = issues.issue_id
