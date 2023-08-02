class SingleStat < ApplicationRecord
  belongs_to :game, foreign_key: 'game_id'
  belongs_to :team, foreign_key: 'team_id'

  belongs_to :first_player , class_name: 'Player'
  belongs_to :second_player , class_name: 'Player', optional: true

  enum stat_type: { goal: 'Bramka', own_goal: 'Bramka samobójcza', yellow_card: 'Żółta kartka', red_card: 'Czerwona kartka', subs: 'Zmiana'}


  def stat_type_name
    case stat_type
    when 'goal'
      'Bramka'
    when 'own_goal'
      'Bramka samobójcza'
    when 'yellow_card'
      'Żółta kartka'
    when 'red_card'
      'Czerwona kartka'
    when 'subs'
      'Zmiana'
    else
      'Nieznany'
    end
  end
end
