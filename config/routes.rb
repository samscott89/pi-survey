SurveyApp::Application.routes.draw do

  #
  # Static Links
  #
  # Standard links to static pages.
  #
  root to: 'static_pages#home'
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"

  get "/tour", to: "static_pages#tour"

  #
  # User links
  #
  devise_for :users
  get "/mysurveys", to: "users#show", as: "user_surveys"

  # Used for reviewing and saving surveys done by guest accounts
  get "/review_surveys", to: "users#review_surveys", as: "review_surveys"
  match "/save_surveys", to: "users#save_surveys", as: "save_surveys", via: 'post'

  ###########################
  #                         #
  #                         #
  #        Surveys          #
  #                         #
  #                         #
  ###########################

  #
  # Nested Survey Resources
  #
  # Nested resources such as survey_sections, stats and answers.
  #
  resources :surveys do
    #This allows survey sections to be called relative to 
    # a survey. E.g. survey_section_path(@survey, :index)
    get "/sec/:index", to: "survey_sections#show", as: :section
    match "/sec/:index", to: "survey_sections#update", via: 'put', as: :update_section
    get "/edit/:index", to: "surveys#edit", as: :edit_section
    match "/sec/:index", to: "survey_sections#delete", as: :delete_section, via: 'delete'
   
    get "/stats", to: "surveys#stats", as: :stats
    get "/charts", to: "surveys#charts", as: :charts
    get "/chartcreate", to: "surveys#chartcreate"
    #get "/chartsgo", to: "charts#show"
    match "/new_section", to: "survey_sections#new", as: :new_section, via: "post"
    
    match "/sec/:index/submit", to: 'survey_sections#answer', via: 'post', as: :answer
    get "/finish", to: 'surveys#finish', via: 'get', as: :completed
  end

  resources :charts

  #
  # Questions
  #
  # Separate resources for questions (mostly for editing)
  #
  resources :questions, only: [:create, :update, :destroy]
  # match "/questions/:question_id", to: "questions#update", via: 'post', as: "edit_question"


  #
  # Campaigns
  #
  # Resource for viewing campaigns etc.
  #
  resources :campaigns do 
    resources :campaign_surveys, only: [:destroy], shallow: true
    resources :participants, only: [:index]  do
      collection do 
        get "add"
        match "edit", via: :post
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
