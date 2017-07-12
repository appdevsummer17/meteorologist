require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================
    
    # Get coordinates from Google maps
    #
    google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address.gsub(" ", "+")
    
    maps_results = JSON.parse(open(google_maps_url).read)

    @lat = maps_results["results"][0]["geometry"]["location"]["lat"].to_s
    
    @lng = maps_results["results"][0]["geometry"]["location"]["lng"].to_s
    
    # Get coordinates from dark sky
    #
    dark_sky_url = "https://api.darksky.net/forecast/a52814fad0486c985720046e82a2e4fa/" + @lat + "," + @lng
    
    dark_sky_results = JSON.parse(open(dark_sky_url).read)
    
    # Return data for the page
    #
    @current_temperature = dark_sky_results["currently"]["temperature"].round(2)

    @current_summary = dark_sky_results["currently"]["summary"]

    @summary_of_next_sixty_minutes = dark_sky_results["minutely"]["summary"]

    @summary_of_next_several_hours = dark_sky_results["hourly"]["summary"]

    @summary_of_next_several_days = dark_sky_results["daily"]["summary"]

    # Render the page
    #
    render("meteorologist/street_to_weather.html.erb")
  end
end
