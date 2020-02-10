class Vote < ApplicationRecord    
  belongs_to :poker_session
  belongs_to :user

  validates :value, presence: :true   
end
