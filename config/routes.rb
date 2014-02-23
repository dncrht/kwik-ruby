Kwik::Application.routes.draw do

  match '404' => 'errors#not_found'
  match '500' => 'errors#server_error'

  get Kwik::Application.config.ALL_PAGE => 'main#show_all', :page => Kwik::Application.config.ALL_PAGE.dup, :as => :show_all
  get ':page' => 'main#show', :as => :show
  get ':page/edit' => 'main#edit', :as => :edit
  put ':page/edit' => 'main#preview', :constraints => lambda { |request| request.params[:commit] == 'Preview' }
  put ':page/edit' => 'main#update'
  delete ':page' => 'main#destroy'

  root :to => 'main#search', :constraints => lambda { |request| request.params[:terms] =~ /\w+/ }
  root :to => 'main#show'

end
