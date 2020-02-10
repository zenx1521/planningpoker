class VotesCreation
  attr_reader :errors
  attr_reader :vote

  def initialize(session,user,params)
    @session = session
    @user = user
    @params = params
    @errors = []
  end

  def call
    result = false
    @session.with_lock do
      @session.votes.each do |vote|
        if vote.user.id == @user.id
          @errors.push("ALREADY VOTED")
        end
      end

      if @session.finished
        @errors.push('SESSION FINISHED')
      end

      @vote = @session.votes.new(vote_params)
      @vote.user_id = @user.id
      
      if vote.save
        if @session.votes.count == @session.number_of_voting
          @session.finished = true
        end

        if !@session.save
          @errors.push("SESSION NOT UPDATED")
        end
        
      else 
        @errors.push("SESSION NOT SAVED")
      end

      if @errors.empty?
        result = true
      else 
        raise ActiveRecord::Rollback
      end

      result
    end
  end

  private

  def vote_params
    @params.permit(:value)
  end
end