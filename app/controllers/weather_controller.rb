class WeatherController < ApplicationController
    def index
    end
    def location
        app_id = Rails.application.credentials.open_weather_key
        response = Faraday.get("http://api.openweathermap.org/data/2.5/weather?lat=#{location_params[:lat]}&lon=#{location_params[:lon]}&appid=#{app_id}")
        puts response.body
    end
    private
    def location_params
        params.permit(:lat, :lon)
    end
end
