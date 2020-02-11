module Api
  module V1
    class PokerSessionsController < ApplicationController
      def create
        user = User.where(:token => params[:token]).first
        session = user.poker_sessions.new(session_params)

        if session.save 
          render json: {status: 'SUCCESS', data: session}, status: :ok
        else 
          render json: {status: 'ERROR', error: 'SESSION_NOT_SAVED'}, status: :unprocessable_entity
        end
      end 

      def return_stats
        session = PokerSession.find(params[:id])

        render json: {status: 'SUCCESS', data: session.to_json(except: [:updated_at,:created_at], include: {votes: {include: :user}})} , status: :ok

        #if session.finished
        #  render json: {status: 'SUCCESS', data: session.to_json(except: [:updated_at,:created_at], include: {votes: {include: :user}})} , status: :ok
        #else
        #  render json: {status: 'SUCCESS', data: session.to_json(except: [:updated_at,:created_at], include: {votes: {include: :user}})} , status: :ok
        #end
      end

      def reset_session
        session = PokerSession.find(params[:id])

        if session.user.token != params[:token] 
          render json: {status: 'ERROR', error: 'ACCESS_DENIED'}, status: :unprocessable_entity
          return
        end
        session.votes.destroy_all
        session.votes_count = 0
        session.finished = false

        if session.save 
          render json: {status: 'SUCCESS', data: session}, status: :ok
        else 
          render json: {status: 'ERROR', error: "SESSION_NOT_REOPENED"}, status: :unprocessable_entity
        end
      end
      
      private

      def session_params 
        params.permit(:number_of_voting)
      end
    end
  end
end