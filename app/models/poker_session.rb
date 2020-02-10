class PokerSession < ApplicationRecord
    validates :number_of_voting, presence:true

    has_many :votes

    belongs_to :user
end
