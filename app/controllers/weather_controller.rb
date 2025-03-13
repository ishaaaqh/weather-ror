class WeatherController < ApplicationController
    require 'httparty'
    
    def new
        # Just renders the form
    end

    def show
      address = params[:address]
      return unless address.present?
  
      # Geocode address to get latitude & longitude
      location = Geocoder.search(address).first
      if location
        zip_code = location.postal_code || "unknown"
        cache_key = "weather_#{zip_code}"
        # Check cache
        cached_data = Rails.cache.read(cache_key)
        if cached_data
          @weather = cached_data
          @from_cache = true
        else
          @weather = fetch_weather(location.latitude, location.longitude)
          Rails.cache.write(cache_key, @weather, expires_in: 30.minutes)
          @from_cache = false
        end
      else
        @error = "Please enter a valid city or zip code"
      end
    end
  
    private
  
    def fetch_weather(lat, lon)
      api_key = ENV['OPENWEATHER_API_KEY']
      url = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{api_key}&units=metric"
      response = HTTParty.get(url)
      binding.pry
      if response.success?
        {
          temp: response["main"]["temp"],
          high: response["main"]["temp_max"],
          low: response["main"]["temp_min"],
          condition: response["weather"].first["description"]
        }
      else
        nil
      end
    end
  end
  