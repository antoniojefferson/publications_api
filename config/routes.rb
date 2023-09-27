Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :authentication do
        post :sign_in, defaults: { format: :json }
      end

      resources :comments, defaults: { format: :json }
      resources :posts, defaults: { format: :json }
      resources :users, defaults: { format: :json }
    end
  end
end
