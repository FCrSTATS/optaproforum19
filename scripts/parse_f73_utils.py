# parse f73 xml
import xml.etree.ElementTree as ET
import numpy as np
import pandas as pd

def parse_xml(file_name):
    # parse the xml and convert to a tree and root
    tree = ET.parse(file_name)
    root = tree.getroot()

    ## get the main game info from the single 'Game' node
    gameinfo = root.findall('Game')
    gameinfo = gameinfo[0]
    game_id = gameinfo.get('id')
    home_team_id = gameinfo.get('home_team_id')
    home_team_name = gameinfo.get('home_team_name')
    away_team_id = gameinfo.get('away_team_id')
    away_team_name = gameinfo.get('away_team_name')
    competition_id = gameinfo.get('competition_id')
    competition_name = gameinfo.get('competition_name')
    season_id = gameinfo.get('season_id')

    Edata_columns = ['id',
             'event_id',
             'type_id',
             'period_id',
             'min',
             'sec',
             'outcome',
             'player_id',
             'team_id',
             'x',
             'y',
             'sequence_id',
             'possession_id',
            ]

    Q_ids = []
    Q_values = []
    Edata = []

    
    # loop through each event node and grab the information
    for i in root.iter('Event'):

        # get the info from the Event node main chunk
        id_ = int(i.get('id'))
        event_id = i.get('event_id')
        type_id = i.get('type_id')
        period_id = int(i.get('period_id'))
        outcome = int(i.get('outcome'))
        min_ = int(i.get('min'))
        sec = int(i.get('sec'))
        player_id = i.get('player_id')
        player_id = str(player_id)
        team_id = i.get('team_id')
        x = i.get('x')
        y = i.get('y')
        possession_id = i.get('possession_id')
        sequence_id = i.get('sequence_id')

        Edata_values = [id_, event_id, type_id, period_id, min_, sec, outcome, player_id, team_id,
                        x,y, sequence_id, possession_id]

        # find all of the Q information for that file
        Qs = i.findall("./Q")

        # create some empty lists to append the results to
        qualifier_id = []
        Q_value = []

        # loop through all of the Qs and grab the info
        for child in Qs:
            qualifier_id.append(child.get('qualifier_id'))
            Q_value.append(child.get('value'))

        Q_ids.append(qualifier_id)
        Q_values.append(Q_value)
        Edata.append(Edata_values)

    #Stack all Event Data
    df = pd.DataFrame(np.vstack(Edata), columns = Edata_columns)


    unique_Q_ids = np.unique(np.concatenate(Q_ids))

    #create an array for fast assignments
    Qarray = np.zeros((df.shape[0] ,len(unique_Q_ids)))
    Qarray = Qarray.astype('O')
    Qarray[:] = np.nan

    #dict to relate Q_ids to array indices
    keydict = dict(zip(unique_Q_ids, range(len(unique_Q_ids))))

    #iter through all Q_ids, Q_values, assign values to appropriate indices
    for idx, (i, v) in enumerate(zip(Q_ids, Q_values)):
        Qarray[idx, [keydict.get(q) for q in Q_ids[idx]]] = Q_values[idx]

    #df from array
    Qdf = pd.DataFrame(Qarray, columns = unique_Q_ids, index = df.index)

    #combine
    game_df = pd.concat([df, Qdf], axis = 1)

    #assign game values
    game_df['competition_id'] = competition_id
    game_df['game_id'] = game_id
    game_df['home_team_id'] = home_team_id
    game_df['home_team_name'] = home_team_name
    game_df['away_team_id'] = away_team_id
    game_df['away_team_name'] = away_team_name
    game_df['competition_id'] = competition_id
    game_df['competition_name'] = competition_name
    game_df['season_id'] = season_id
    game_df['competition_id'] = competition_id

    game_df[['id','period_id','min','sec','outcome']] = \
                game_df[['id','period_id','min','sec','outcome']].astype('int')

    # write to csv
    return game_df
