module Api
    module V1
        class VotesController < ApplicationController
            def create                
                if !PokerSession.where(:id => params[:poker_session_id]).exists?
                    render json: {status: 'ERROR', message: 'Session with this id doesn\'t exist', data: nil}, status: :unprocessable_entity
                    return
                end

                session = PokerSession.find(params[:poker_session_id])
                user = User.where(:token => params[:token]).first

                session.votes.each do |vote|
                    if vote.user.id == user.id
                        render json: {status: 'ERROR', message: 'You have voted already', data: nil}, status: :unprocessable_entity
                        return
                    end
                end

                if session.finished
                    render json: {status: 'ERROR', message: 'Session has finished', data: nil}, status: :unprocessable_entity
                else 
                    vote = session.votes.new(vote_params)
                    vote.user_id = user.id
                    if vote.save 
                        session.votes_count += 1

                        if session.votes_count == session.number_of_voting
                            session.finished = true
                        end

                        session.save

                        render json: {status: 'SUCCESS', message: 'Saved vote', data: vote}, status: :ok
                    else 
                        render json: {status: 'ERROR', message: 'Didn\'t save a vote', data: nil}, status: :unprocessable_entity
                    end
                end
            end

            private 

            def vote_params
                params.permit(:value)
            end
        end
    end
end 