require './app/presenters/admin_presenter/index'

class AdminController < ApplicationController
  def index
    @presenter = Presenters::AdminPresenter::Index.new
  end
end
