DROP TABLE IF EXISTS matches_mr;
CREATE EXTERNAL TABLE matches_mr ( 
    team_id STRING,
    season INT,
    matches_played INT,
    avg_goals_per_match DOUBLE
    )
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE
    LOCATION '${hivevar:input_dir3}';

DROP TABLE IF EXISTS teams;
CREATE EXTERNAL TABLE teams (
    team_id STRING,
    name STRING,
    city STRING,
    league STRING,
    coach STRING
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '${hivevar:input_dir4}'
    TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS ranking;
CREATE EXTERNAL TABLE ranking (
    league STRING,
    total_matches INT,
    avg_goals_per_match DOUBLE,
    teams_ranking ARRAY<STRUCT<team_id: STRING, rank_in_league: INT>>
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
STORED AS TEXTFILE
LOCATION '${hivevar:output_dir6}';


WITH team_stats AS (
    SELECT  m.team_id,
            t.league,
            SUM(m.matches_played) as team_matches,
            SUM(m.matches_played*m.avg_goals_per_match) as team_goals

    FROM matches_mr m INNER JOIN teams t ON m.team_id = t.team_id
    GROUP BY m.team_id, t.league
),
team_ranks AS (
    SELECT  team_id,
            league, 
            team_matches, 
            team_goals, 
            RANK() OVER (PARTITION BY league ORDER BY team_matches DESC) AS rank_in_league
    FROM team_stats
)
INSERT OVERWRITE TABLE ranking
SELECT  
        league,
        SUM(team_matches) as total_matches,
        SUM(team_goals)/SUM(team_matches) AS avg_goals_per_match,
        COLLECT_LIST(NAMED_STRUCT('team_id', team_id, 'rank_in_league', rank_in_league))
FROM team_ranks
GROUP BY league;


