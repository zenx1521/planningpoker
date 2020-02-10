module Api
    module V1
        class PokerSessionsController < ApplicationController

            def create
                user = User.where(:token => params[:token]).first
                session = user.poker_sessions.new(session_params)



                if session.save 
                    render json: {status: 'SUCCESS', message:'Saved session', data: session}, status: :ok
                else 
                    render json: {status: 'ERROR', message:'Didnt save a session', data: session.errors}, status: :unprocessable_entity
                end
            end 

            def return_stats
                session = PokerSession.find(params[:id])
                if session.finished
                    render json: {status: 'SUCCESS', message: 'Session has finished', data: session.to_json(except: [:updated_at,:created_at], include: {votes: {include: :user}})} , status: :ok
                else
                    render json: {status: 'SUCCESS', data: session.to_json(only: [:votes_count,:number_of_voting])} , status: :ok
                end

            end

            def reset_session
                if !PokerSession.where(:id => params[:id]).exists?
                    render json: {status: 'ERROR', message:'Session with this id doesn\'t exist', data: nil}, status: :unprocessable_entity
                    return
                end

                session = PokerSession.find(params[:id])

                if session.user.token != params[:token] 
                    render json: {status: 'ERROR', message:'This session doesn\'t belong to You!', data: nil}, status: :unprocessable_entity
                    return
                end
                session.votes.destroy_all
                session.votes_count = 0
                session.finished = false

                if session.save 
                    render json: {status: 'SUCCESS', message:'Reopened a session', data: session}, status: :ok
                else 
                    render json: {status: 'ERROR', message:'Didnt reopen session', data: nil}, status: :unprocessable_entity
                end

            end
            

            private

            def session_params 
                params.permit(:number_of_voting)
            end
        end
    end
end