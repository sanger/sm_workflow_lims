class AdminController < ApplicationController

  def index
    @presenter = Presenter::AdminPresenter::Index.new
  end

end