Rails.application.routes.draw do
  get "/" => "hands#top"
  post "hands/judge" => "hands#judge"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
