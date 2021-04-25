Rails.application.routes.draw do
  get '/' => 'poker_hands#top'
  post 'poker_hands/judge' => 'poker_hands#judge'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.
  namespace :api, { format: 'json' } do
    namespace :poker_hands_apis do
      post '/', action: 'judge'
    end
  end
end
