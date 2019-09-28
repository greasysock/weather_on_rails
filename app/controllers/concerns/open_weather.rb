module OpenWeather
  include ActiveSupport::Concern  
  
  # Fetch and serialize data for client weather view
  def fetch_six_day_forecast_at lat, lon
    app_id = Rails.application.credentials.open_weather_key
    todays_weather_response = Faraday.get("http://api.openweathermap.org/data/2.5/weather?units=imperial&lat=#{lat}&lon=#{lon}&appid=#{app_id}")
    five_day_forecast_response = Faraday.get("http://api.openweathermap.org/data/2.5/forecast?units=imperial&lat=#{lat}&lon=#{lon}&appid=#{app_id}")
    todays_weather = JSON.parse(todays_weather_response.body)
    five_day_forecast = JSON.parse(five_day_forecast_response.body)

    # This is the serialized version being sent to the client. It only contains relevant information. Just the location followed by the six-day forecast
    six_day_forecast_serialized = {
      :location => "#{todays_weather["name"]}, #{todays_weather["sys"]["country"]}",
      :forecast => [
        todays_weather["main"]["temp"]
      ]
    }

    # Used to shift all frame of time to correct offset. Could not find any built-in methods to set a fixed offset.
    utc_offset = five_day_forecast["city"]["timezone"]

    # Find the current day (tomorrow) and the day after relative to the client
    current_day = (Time.zone.now + utc_offset).beginning_of_day.tomorrow
    next_day = current_day.tomorrow

    # Set the loop up with the first measurement
    highest_high = nil

    # Create index for moving days
    day_index = 1

    five_day_forecast["list"].each do |forecast|
      # Find current time by UTC and then offset with given offset to make sure the day ranges are correct to capture the correct high's regardless of timezone
      current_time = Time.zone.at(forecast["dt"]+utc_offset)
      temp = forecast["main"]["temp"]

      if (current_time >= current_day) and (current_time < next_day)
        if (!highest_high) or (temp > highest_high)
          six_day_forecast_serialized[:forecast][day_index] = temp 
          highest_high = temp
        end
      elsif current_time >= next_day
        highest_high = temp
        day_index += 1
        six_day_forecast_serialized[:forecast][day_index] = temp 
        current_day = current_day.tomorrow
        next_day = current_day.tomorrow
      end

    end

    six_day_forecast_serialized
  end
end