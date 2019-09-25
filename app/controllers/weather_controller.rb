class WeatherController < ApplicationController
    include OpenWeather
    def index
    end
    def location
        serialized_weather = fetch_six_day_forecast_at location_params[:lat], location_params[:lon]
        respond_to do |format|
            format.json{render :json => serialized_weather}
        end
    end
    private
    def location_params
        params.permit(:lat, :lon)
    end
end
