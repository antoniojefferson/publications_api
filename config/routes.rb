Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :authentication do
        post :sign_in, defaults: { format: :json }
      end

      resources :users, defaults: { format: :json }
    end
  end
end
