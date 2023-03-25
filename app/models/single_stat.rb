class SingleStat < ApplicationRecord
  belongs_to :game, foreign_key: 'game_id'
  belongs_to :team, foreign_key: 'team_id'
  belongs_to :player, class_name: 'Player', foreign_key: 'player_id'
  belongs_to :assistant, class_name: 'Player', foreign_key: 'assistant_id'

  enum stat_type: { goal: 'goal', own_goal: 'own goal', yellow_card: 'yellow card',    red_card: 'red card'}

end
