Rails.application.routes.draw do
  resources :documents
  resources :complains do
   
    member do
        post 'caseReport'
    end
  end
    get '/index_oficial' => 'complains#index_oficial'
    get '/index_aux' => 'complains#index_aux'
    post '/index2' => 'complains#index2'
    get '/index2' => 'complains#index2'
    get '/index3' => 'complains#index3'
    get '/index4' => 'complains#index4'
    post '/complains'=>'complains#patrol_unit_asign'
    put '/complains'=>'complains#patrol_unit_asign'
    put '/complains?:id'=>'complains#case_report'
    get '/index_logs'=> 'complains#index_logs'
    get '/report'=> 'complains#report'
    get '/graph_report'=> 'complains#graph_report'
    get '/index_contravertions'=> 'complains#index_contravertions'
    post "/push" => "push_notifications#create"
    post "/subscribe" => "subscriptions#create"
    get "/all_complains"=> "complains#all_complains"
  resources :patrol_units
    resources :reports, except: [:new,:index]

    devise_for :users
    post '/complains/:id/' => 'complains#show'
devise_scope :user do
  authenticated :user do
    root 'static_pages#home', as: :authenticated_root
  end
  root 'static_pages#home'

  unauthenticated do
    root 'devise/sessions#new', as: :unauthenticated_root
  end
end


    # resources :people
    # devise_for :users, :controllers => {:registrations => 'registrations'}
    # devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
    #devise_for :users

    get '/logout' => 'static_pages#logout'



    resources :users
    resources :companies
    resources :projects
    resources :roles
    resources :crimes
    resources :contravertions
  get '/legal_agents/new/:company_id' => 'legal_agents#new2'
  resources :legal_agents ,except: [:update]
    post '/legal_agents/:id/update' => 'legal_agents#update'

    resources :employees
    post '/employees/:id/update' => 'employees#update'
    get '/employees/:id/update' => 'employees#edit'

    get '/orders/subregion_options' => 'static_pages#subregion_options'

    get '/users/annul/:id' => 'users#annul'
    get '/users/activate/:id' => 'users#activate'

    # get 'error' => 'static_pages#error'
    post '/createuser' => 'users#create'
    get '/verify/:id' => 'verified_lists#verify'

    get '/employeeAnnouncements' => 'announcements#employeeAnnouncements'
    get '/:dummy' => 'static_pages#error'
    get '/fonts/:dummy' => 'static_pages#error'
    get '/assets/underscore-min.map' => 'static_pages#error'



end
