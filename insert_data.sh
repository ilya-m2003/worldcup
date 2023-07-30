#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    echo $team_id
    if [[ -z $team_id ]]
    then
      insert_team_result=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $insert_team_result == "INSERT 0 1" ]]
      then
        echo Inserted into name, $winner
      fi
    fi
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $team_id ]]
    then
      insert_team_result=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $insert_team_result == "INSERT 0 1" ]]
      then
        echo Inserted into name, $OPPONENT
      fi
    fi
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    insert_game_result=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $winner_id, $opponent_id, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $insert_team_result == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR, $ROUND, $winner_id, $opponent_id, $WINNER_GOALS, $OPPONENT_GOALS
    fi
  fi
done
