class ImportersController < ApplicationController
  def new
  end

  def create
    if params[:data] && Importer.new(params[:data].tempfile.read).process

      # TODO: change this to opening_times path once implemented
      redirect_to new_importers_path
    else
      session[:errors] = 'Please select a file to upload'
      render :new
    end
  end
end
