require './app/presenters/admin/index'

class AdminController < ApplicationController

  def index
    @presenter = Presenter::AdminPresenter::Index.new
  end

end