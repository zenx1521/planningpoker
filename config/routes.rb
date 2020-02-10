Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :poker_sessions, only: [:create] do 
        resources :votes, only: [:create]
        member do
          get :return_stats
          post :reset_session
        end
      end
      post 'users/authenticate'
    end
  end
end
