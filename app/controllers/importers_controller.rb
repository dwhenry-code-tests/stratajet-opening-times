class ImportersController < ApplicationController
  def new
  end

  def create
    if params[:data]
      importer = Importer.new
      data = params[:data].tempfile.read
      if importer.process(data)
        flash[:notice] = 'File successfully imported'
        redirect_to opening_times_path
      else
        flash[:alert] = importer.errors
        render :new
      end
    else
      flash[:alert] = 'Please select a file to upload'
      render :new
    end
  end
end
