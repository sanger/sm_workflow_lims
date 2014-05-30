require 'sinatra/base'
require 'sinatra/activerecord'

class SmWorkflowLims < Sinatra::Base

  # Need to find somewhere better for this, but lets just stop the messages for now.
  I18n.enforce_available_locales = true

  get '/' do
    redirect to('/batches/new')
  end

  get '/assets' do
    AssetsController.new(params).get_index
    # A list of all in progress assets
  end

  put '/assets' do
    AssetsController.new(params).put
    # Propose that 'complete' is set as an array of asset ids to complete
  end

  get '/batches/new' do
    BatchesController.new(params).get_new
    # Build up a list of assets to register, and assign them to a workflow
  end

  get '/batches/:id' do
    BatchesController.new(params).get
    # A quick summary of a batch and its assets, mainly as feedback after registration
  end

  put '/batches/:id' do
    BatchesController.new(params).put
    # Updates a batch workflow
  end

  post '/batches' do
    BatchesController.new(params).post
    # Registers assets to a workflow, suggested format of put request
    # workflow_id=1&comment=''&asset[0][identifier]='Barcode'&asset[0][sample_count]=23&asset[1][identifier]='Barcode'&asset[1][sample_count]=23
  end


  # Error handling
  error do
    send_file 'public/500.html', :status => 500
  end

  not_found do
    send_file 'public/404.html', :status => 404
  end

end
