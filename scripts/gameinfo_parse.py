# process the game data from the f73 files to create an
# dataframe of game information for later use

import glob
import pandas as pd
import numpy as np
import xml.etree.ElementTree as ET

file_list = glob.glob("Data/f73_raw/*.xml")

game_id = []
home_team_id = []
home_team_name = []
away_team_id = []
away_team_name = []
competition_id = []
competition_name = []
season_id = []
game_date = []
matchday = []
period_1_start = []
period_2_start = []

i = file_list[1]
print(i)

for i in file_list:
    tree = ET.parse(i)
    root = tree.getroot()
    gameinfo = root.findall('Game')
    gameinfo = gameinfo[0]
    game_id.append(gameinfo.get('id'))
    home_team_id.append(gameinfo.get('home_team_id'))
    home_team_name.append(gameinfo.get('home_team_name'))
    away_team_id.append(gameinfo.get('away_team_id'))
    away_team_name.append(gameinfo.get('away_team_name'))
    competition_id.append(gameinfo.get('competition_id'))
    competition_name.append(gameinfo.get('competition_name'))
    season_id.append(gameinfo.get('season_id'))
    game_date.append(gameinfo.get('game_date'))
    matchday.append(gameinfo.get('matchday'))
    period_1_start.append(gameinfo.get('period_1_start'))
    period_2_start.append(gameinfo.get('period_2_start'))

GameInfoDataframe = pd.DataFrame(
    {'game_id': game_id,
    'home_team_id': home_team_id,
    'home_team_name': home_team_name,
    'away_team_id': away_team_id,
    'away_team_name': away_team_name,
    'competition_id': competition_id,
    'competition_name': competition_name,
    'season_id': season_id,
    'game_date': game_date,
    'matchday': matchday,
    'period_1_start': period_1_start,
    'period_2_start': period_2_start
    })

GameInfoDataframe.to_csv('Data/GameInfoDatabase.csv', sep=",")
