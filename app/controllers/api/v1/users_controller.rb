module Api
  module V1
    class UsersController < ApplicationController
      def authenticate
        if User.where(:token => params[:token]).exists?
          render json: {status: 'SUCCESS'}, status: :ok
        else 
          render json: {status: 'ERROR', error: "USER_NOT_FOUND"}, status: :ok
        end 
      end
    end
  end
end