class StaticPagesController < ApplicationController
  before_action :set_search
  
  def home
    @trip_recent = Trip.all.includes([:user]).limit(MAX_OF_DISPLAY_RECENT_TRIPS)
  end

  def about
  end
end
