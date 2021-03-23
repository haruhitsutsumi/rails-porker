Rails.application.routes.draw do
  get "/" => "poker_hands#top"
  post "pokerHands/judge" => "poker_hands#judge"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
