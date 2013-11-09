Kwik::Application.routes.draw do

  match '404' => 'errors#not_found'
  match '500' => 'errors#server_error'

  get 'All' => 'main#show_all', :page => 'All', :as => :show_all
  get ':page' => 'main#show', :as => :show
  get ':page/edit' => 'main#edit', :as => :edit
  put ':page/edit' => 'main#update'
  delete ':page' => 'main#destroy'

  root :to => 'main#search', :constraints => lambda { |request| request.params[:terms] =~ /\w+/ }
  root :to => 'main#show'

end
