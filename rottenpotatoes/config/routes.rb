Rottenpotatoes::Application.routes.draw do
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  resources :movies do
    member do
      get :similar_director
    end
  end
end