class AdminController < ApplicationController
  def index
    @presenter = AdminPresenter::Index.new
  end
end
