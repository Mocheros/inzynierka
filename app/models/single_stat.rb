class SingleStat < ApplicationRecord
  belongs_to :game, foreign_key: 'game_id'
  belongs_to :team, foreign_key: 'team_id'

  enum stat_type: { goal: 'Bramka', own_goal: 'Bramka samobójcza', yellow_card: 'Żółta kartka', red_card: 'Czerwona kartka', subs: 'Zmiana'}

end
