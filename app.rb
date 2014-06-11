require 'sinatra/base'
require 'sinatra/activerecord'
require 'sass'
require 'bootstrap-sass'
require 'sinatra/assetpack'
require 'pry-nav'
require './app/manifest'

class SmWorkflowLims < Sinatra::Base
 set :root, File.dirname(__FILE__)
  # Need to find somewhere better for this, but lets just stop the messages for now.
  I18n.enforce_available_locales = true

  set :views, settings.root + '/app/views'
  set :method_override, true
  set :server, :puma

  configure :development do
    set :show_exceptions => :after_handler
  end

  register Sinatra::AssetPack

  assets do

    serve '/assets/javascripts', :from => 'app/assets/javascripts'
    serve '/assets/stylesheets', :from => 'app/assets/stylesheets'

    css :application, '/assets/stylesheets/app.css', [
      '/assets/stylesheets/*.css',
    ]

    js :application, '/assets/javascripts/app.js', [
      '/assets/javascripts/jquery.min.js',
      '/assets/javascripts/bootstrap.min.js',
      '/assets/javascripts/application.js'
    ]


    js_compression :jsmin
    css_compression :sass
  end

  enable :sessions

  get '/' do
    redirect to('/batches/new')
  end

  get '/assets' do
    presenter = AssetsController.new(params).get_index
    # A list of all in progress assets
    erb :'assets/index', :locals=>{:presenter=>presenter}
  end

  put '/assets' do
    presenter = AssetsController.new(params).put
    # Propose that 'complete' is set as an array of asset ids to complete
    identifiers = presenter.asset_identifiers
    session[:flash] = ['success',"#{identifiers.to_sentence} were marked as completed."]
    redirect to('/assets')
  end

  get '/batches/new' do
    presenter = BatchesController.new(params).get_new
    # Build up a list of assets to register, and assign them to a workflow
    erb :'batches/new', :locals=>{:presenter=>presenter}
  end

  get '/batches/:batch_id' do
    presenter = BatchesController.new(params).get
    # A quick summary of a batch and its assets, mainly as feedback after registration
    erb :'batches/show', :locals=>{:presenter=>presenter}
  end

  put '/batches/:batch_id' do
    presenter = BatchesController.new(params).put
    # Updates a batch workflow
    session[:flash] = ['success',"The batch was updated."]
    redirect to("/batches/#{params[:batch_id]}")
  end

  post '/batches' do
    presenter = BatchesController.new(params).post
    # Registers assets to a workflow, suggested format of put request
    # workflow_id=1&comment=''&asset[0][identifier]='Barcode'&asset[0][sample_count]=23&asset[1][identifier]='Barcode'&asset[1][sample_count]=23
    session[:flash] = ['success',"The batch was created."]
    redirect to("/batches/#{presenter.id}")
  end

  error Controller::ParameterError do
    session[:flash] = ['danger', env['sinatra.error'].message ]
    redirect back
  end

  # Error handling
  error do
    send_file 'public/500.html', :status => 500
  end

  not_found do
    send_file 'public/404.html', :status => 404
  end

  after do
    ActiveRecord::Base.connection_pool.release_connection
  end

  def render_messages
    if session[:flash].present?
      yield(*session[:flash])
      session[:flash] = nil # unset the value
    end
  end

end
