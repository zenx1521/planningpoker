module Api
  module V1
    class VotesController < ApplicationController
      def create                
        session = PokerSession.includes(:votes).find(params[:poker_session_id])
        user = User.where(:token => params[:token]).first
        creator = VotesCreation.new(session,user,vote_params)

        if creator.call
          render json: {status: 'SUCCESS',  data: creator.vote}, status: :ok
        else
          render json: {status: 'ERROR', errors: creator.errors}, status: :unprocessable_entity
        end
      end

      private

      def vote_params
        params.permit(:value)
      end
    end
  end
end 