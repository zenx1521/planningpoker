module Api
  module V1
    class VotesController < ApplicationController
      def create                
        session = PokerSession.includes(:votes).find(params[:poker_session_id])
        user = User.where(:token => params[:token]).first
        creator = VotesCreation.new(session,user,params)

        vote = creator.call

        if vote
          render json: {status: 'SUCCESS', message: 'Saved vote', data: vote}, status: :ok
        else
          render json: {status: 'ERROR', message: creator.errors, data: nil}, status: :unprocessable_entity
        end
      end
    end
  end
end 