require './app/controllers/controller'

class AdminController < Controller

  def index
    Presenter::AdminPresenter::Index.new
  end

end
