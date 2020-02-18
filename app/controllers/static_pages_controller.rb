class StaticPagesController < ApplicationController
  MAX_OF_DISPLAY_RECENT_TRIPS = 5
  def home
    @trip_recent = Trip.all.limit(MAX_OF_DISPLAY_RECENT_TRIPS)
  end

  def about
  end
end
