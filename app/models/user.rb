class User < ApplicationRecord
    before_create :set_token 
    has_many :votes
    has_many :poker_sessions

    private 

    def set_token
        self.token = generate_token
    end

    def generate_token
        loop do
            token = SecureRandom.hex(3)
            break token unless User.where(token: token).exists?
        end 
    end
end
