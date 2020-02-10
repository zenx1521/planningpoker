module Api
    module V1
        class UsersController < ApplicationController
            def authenticate
                if User.where(:token => params[:token]).exists?
                    render json: {status: 'SUCCESS', message:'Logged in successfuly', data: nil}, status: :ok
                else 
                    render json: {status: 'ERROR', message:'User not found', data: nil}, status: :ok
                end 
            end
        end
    end
end