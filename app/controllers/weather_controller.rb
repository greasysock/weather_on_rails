class WeatherController < ApplicationController
    def index
    end
    def location
        puts '*'*100
        puts location_params
        puts '*'*100
    end
    private
    def location_params
        params.permit(:lat, :lon)
    end
end
