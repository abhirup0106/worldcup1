#! /bin/bash

# Check if the argument is 'test'
if [[ $1 == "test" ]]; then
  PSQL="psql --username=postgres --dbname=worldcuptest"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup"
fi

# Insert data into the teams table if they don't already exist
$PSQL << EOF
INSERT INTO teams (name) VALUES ('France'), ('Croatia'), ('Belgium'), ('England'), ('Russia'), ('Sweden'), ('Brazil'), ('Uruguay'), ('Argentina'), ('Portugal'), ('Spain'), ('Denmark'), ('Mexico'), ('Switzerland'), ('Colombia'), ('Japan'), ('Netherlands'), ('Costa Rica'), ('Chile'), ('Nigeria'), ('Germany'), ('Algeria'), ('Greece'), ('United States')
ON CONFLICT (name) DO NOTHING;
EOF

# Insert data into the games table from games.csv
while IFS=, read -r year round winner opponent winner_goals opponent_goals; do
  winner_id=$(echo "SELECT team_id FROM teams WHERE name = '$winner'" | $PSQL | sed '3q;d')
  opponent_id=$(echo "SELECT team_id FROM teams WHERE name = '$opponent'" | $PSQL | sed '3q;d')
  echo "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);" | $PSQL
done < games.csv
