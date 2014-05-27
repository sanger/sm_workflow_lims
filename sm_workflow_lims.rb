require 'sinatra/base'

class SmWorkflowLims < Sinatra::Base

  get '/' do
    "Main Page"
    # The landing page.
  end

  get '/assets' do
    "Assets Index"
    # A list of all in progress assets
  end

  put '/assets' do
    "Marking assets as completed"
    # Propose that 'complete' is set as an array of asset ids to complete
  end

  get '/batches/new' do
    "Register Batch"
    # Build up a list of assets to register, and assign them to a workflow
  end

  get '/batches/:id' do
    "View Batch"
    # A quick summary of a batch and its assets, mainly as feedback after registration
  end

  get 'assets/:id' do
    "Show page for asset (if needed)"
    # May not be needed, lets a user move an asset to a new workflow
  end

  put '/assets/:id' do
    "Editing an asset"
    # Receives the form, updates an assets workflow
  end

  post '/batches' do
    "Creating a batch, redirects to batch show page"
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
