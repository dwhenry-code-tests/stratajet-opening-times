class ImportersController < ApplicationController
  def new
  end

  def create
    if params[:data]
      importer = Importer.new
      data = params[:data].tempfile.read
      if importer.process(data)
        # TODO: change this to opening_times path once implemented
        redirect_to new_importers_path
      else
        session[:errors] = importer.error
        render :new
      end
    else
      session[:errors] = 'Please select a file to upload'
      render :new
    end
  end
end
