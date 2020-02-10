class PokerSession < ApplicationRecord
  has_many :votes
  belongs_to :user

  validates :number_of_voting, presence:true
end
