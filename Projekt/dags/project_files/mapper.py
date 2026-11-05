#!/usr/bin/env python3

import sys

def parse_record(row):
    fields = row.strip().split(",")
    return fields  


def transform_and_print(fields):
    match_id = fields[0]
    home_team_id = fields[1]
    away_team_id = fields[2]
    try:
        home_score = int(fields[3])
    except (ValueError, IndexError):
        return
    try:
        away_score = int(fields[4])
    except (ValueError, IndexError):
        return
        
    try:
        date_str = fields[5]
        year = int(date_str[:4])
        month = int(date_str[5:7])
    except (ValueError, IndexError):
        return

    if month < 8:
        season = year - 1
    else:
        season = year

    print(f"{home_team_id},{season}\t{home_score}\t{1}")
    print(f"{away_team_id},{season}\t{away_score}\t{1}")
    


        
if __name__ == "__main__":
    for row in sys.stdin:
        if not row or not row.strip():
            continue
        if row.startswith("match_id"):
            continue

        try:
            fields = parse_record(row)
            if len(fields) != 7:
                continue

        except:
            continue
        
        transform_and_print(fields)    