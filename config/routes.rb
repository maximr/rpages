Rails.application.routes.draw do
  root :to => "pages#root"
  get '/f/:id' => 'pages#file', as: 'static_file'
  get 'not_found' => 'pages#not_found'

  get 'association/:type' => 'pages#get_selection', as: 'get_rpages_selection'
  get 'cb/:id' => 'pages#get_cb_content', as: 'get_cb_content'

  DynamicRouter.load
end