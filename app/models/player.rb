class Player < ApplicationRecord
  belongs_to :team
  has_many :single_stats
  has_many :lineups

  validates :name, presence: true
  validates :position, presence: true
  
  validates :shirt_number, uniqueness: { scope: :team_id, message: "Numer koszulki musi być unikalny dla drużyny" }, if: :shirt_number_present?
  validate :valid_shirt_number, if: :shirt_number_present?

  private

  def shirt_number_present?
    shirt_number.present?
  end
  
  def valid_shirt_number
    unless shirt_number.is_a?(Integer) && shirt_number.between?(0, 99)
      errors.add(:shirt_number, "Numer koszulki musi być liczbą całkowitą z zakresu 0-99")
    end
  end
end
