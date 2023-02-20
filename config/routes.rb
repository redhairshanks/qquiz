Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'user/create', to: "user#create_user"
  post 'user/sign-in', to: "user#sign_in_user"

  post 'poll/create', to: "poll#create_poll"
  post 'poll/start', to: "poll#start_poll"
  post 'poll/end', to: "poll#end_poll"
  get  'poll/participants', to: "poll#fetch_poll_participants"
  post 'poll/share', to: "poll#share_poll"
  get  'poll/:poll_id', to: "poll#show_poll"
  get  'poll/link/:id', to: "poll#get_poll"

  post 'poll/question/create', to: "question#create_question"
  post 'poll/question/answer/create', to: "question#answer_question"



end
