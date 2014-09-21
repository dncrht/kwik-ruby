Rails.application.routes.draw do

  get '404' => 'errors#not_found'
  get '500' => 'errors#server_error'

  get Rails.application.config.ALL_PAGE => 'main#show_all', :page => Rails.application.config.ALL_PAGE.dup, :as => :show_all
  get ':page' => 'main#show', :as => :show
  get ':page/edit' => 'main#edit', :as => :edit
  put ':page/edit' => 'main#preview', :constraints => lambda { |request| request.params[:commit] == 'Preview' }
  put ':page/edit' => 'main#update'
  delete ':page' => 'main#destroy'

  root :to => 'main#search', :constraints => lambda { |request| request.params[:terms] =~ /\w+/ }, :as => :search
  root :to => 'main#show'

end
