module Api
    module V1
        class VotesController < ApplicationController
            def create                
                if !PokerSession.where(:id => params[:poker_session_id]).exists?
                    render json: {status: 'ERROR', message: 'Session with this id doesn\'t exist', data: nil}, status: :unprocessable_entity
                    return
                end

                session = PokerSession.includes(:votes).find(params[:poker_session_id])
                user = User.where(:token => params[:token]).first
                vote = VotesCreation.new(session,user,params).execute

                if vote.class.to_s == "Vote"
                    render json: {status: 'SUCCESS', message: 'Saved vote', data: vote}, status: :ok
                else
                    puts vote.message
                    render json: {status: 'ERROR', message: vote, data: nil}, status: :unprocessable_entity
                end
                #render json: {status: 'ERROR', message: 'You have voted already', data: nil}, status: :unprocessable_entity
                #render json: {status: 'ERROR', message: 'Session has finished', data: nil}, status: :unprocessable_entity
                #render json: {status: 'SUCCESS', message: 'Saved vote', data: vote}, status: :ok
                #render json: {status: 'ERROR', message: 'Didn\'t save a vote', data: nil}, status: :unprocessable_entity
            end

            private 

            def vote_params
                params.permit(:value)
            end
        end
    end
end 