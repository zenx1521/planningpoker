class VotesCreation
  attr_reader :errors

  def initialize(session,user,params)
    @session = session
    @user = user
    @params = params
    @errors = []
  end

  def call
    @session.with_lock do
      @session.votes.each do |vote|
        if vote.user.id == @user.id
          @errors.push("You have voted already")
        end
      end

      if @session.finished
        @errors.push('Session has finished')
      end

      vote = @session.votes.new(vote_params)
      vote.user_id = @user.id
      
      if vote.save
        if @session.votes.count == @session.number_of_voting
          @session.finished = true
        end

        if !@session.save
          @errors.push("Session was not updated")
        end
        
      else 
        @errors.push("Didn\t save a vote")
      end

      unless @errors.empty?
        raise ActiveRecord::Rollback
      else 
        vote
      end
    end
  end

  private

  def vote_params
    @params.permit(:value)
  end
end