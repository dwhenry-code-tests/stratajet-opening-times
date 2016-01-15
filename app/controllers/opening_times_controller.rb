class OpeningTimesController < ApplicationController
  def index
    @opening_times = OpeningTime.all
  end
end
