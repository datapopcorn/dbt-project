import dlt

from github import github_reactions, github_repo_events, github_stargazers


def load_dbt_project_reactions_issues_only() -> None:
    """Loads issues, their comments and reactions for dbt-project"""
    pipeline = dlt.pipeline(
        "github_reactions",
        destination='bigquery',
        dataset_name="github_data",
        dev_mode=False,
    )
    # get only 100 items (for issues and pull request)
    data = github_reactions(
        "datapopcorn", "dbt-project", items_per_page=100, max_items=100
    ).with_resources("issues")
    print(pipeline.run(data))

    pipeline = dlt.pipeline(
        "github_reactions",
        destination='bigquery',
        dataset_name="github_data_dbt",
    )
    # add dbt runner
    dbt = dlt.dbt.package(pipeline, package_location="./dbt_project")

    models = dbt.run(cmd_params=["-s +dim_issues_comments_reactions +fct_issues +fct_comments"])
    # On success, print the outcome
    for m in models:
        print(
            f"Model {m.model_name} materialized" +
            f" in {m.time}" +
            f" with status {m.status}" +
            f" and message {m.message}"
        )

def load_airflow_events() -> None:
    """Loads airflow events. Shows incremental loading. Forces anonymous access token"""
    pipeline = dlt.pipeline(
        "github_events", destination='bigquery', dataset_name="airflow_events"
    )
    data = github_repo_events("apache", "airflow", access_token="")
    print(pipeline.run(data))
    # if you uncomment this, it does not load the same events again
    # data = github_repo_events("apache", "airflow", access_token="")
    # print(pipeline.run(data))


def load_dlthub_dlt_all_data() -> None:
    """Loads all issues, pull requests and comments for dlthub dlt repo"""
    pipeline = dlt.pipeline(
        "github_reactions",
        destination='bigquery',
        dataset_name="dlthub_reactions",
        dev_mode=True,
    )
    data = github_reactions("dlt-hub", "dlt")
    print(pipeline.run(data))


def load_dlthub_dlt_stargazers() -> None:
    """Loads all stargazers for dlthub dlt repo"""
    pipeline = dlt.pipeline(
        "github_stargazers",
        destination='bigquery',
        dataset_name="dlthub_stargazers",
        dev_mode=True,
    )
    data = github_stargazers("dlt-hub", "dlt")
    print(pipeline.run(data))


if __name__ == "__main__":
    load_dbt_project_reactions_issues_only()
    #load_airflow_events()
    #load_dlthub_dlt_all_data()
    #load_dlthub_dlt_stargazers()
