#!/usr/bin/env python3

def parse_record(row):
    fields = row.strip().split("\t")
    if len(fields) != 3:
        return
    key = fields[0]
    try:
        goals = int(fields[1])
        matches = int(fields[2])
    except (ValueError, IndexError):
        return

    return key, goals, matches  




import sys

current_key = None
current_goals = 0
current_matches = 0

for row in sys.stdin:
    if not row or not row.strip():
        continue
   
    record = parse_record(row)
    if not record:
        continue

    key, goals, matches = record

    if key == current_key:
        current_goals += goals
        current_matches += matches
    else:
        if current_key is not None:
            team_id,season = current_key.split(",")
            avg_goals_per_match = current_goals / current_matches
            print(f"{team_id}\t{season}\t{current_matches}\t{avg_goals_per_match}")
        current_key = key
        current_goals = goals
        current_matches = matches

if current_key is not None:
    team_id,season = current_key.split(",")
    avg_goals_per_match = current_goals / current_matches
    print(f"{team_id}\t{season}\t{current_matches}\t{avg_goals_per_match}")


