class VotesCreation
    def initialize(session,user,params)
        @session = session
        @user = user
        @params = params
    end

    def execute
        @session.with_lock do
            @session.votes.each do |vote|
                if vote.user.id == @user.id
                    raise "You have voted already"
                end
            end

            if @session.finished
                raise 'Session has finished'
            end

            vote = @session.votes.new(vote_params)
            vote.user_id = @user.id
            
            if vote.save
                if @session.votes.count == @session.number_of_voting
                    @session.finished = true
                end

                if !@session.save
                    raise "Session was not updated"
                end
                
                return vote
            else 
                raise "Didn\t save a vote"
            end

        end
    rescue RuntimeError => error
        error
    end

    private

    def vote_params
        @params.permit(:value)
    end
end