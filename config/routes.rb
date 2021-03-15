Rails.application.routes.draw do
  get "/" => "hand#top"
  post "hand/judge" => "hand#judge"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
