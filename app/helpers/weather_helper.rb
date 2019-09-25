module WeatherHelper
    def five_day_render
        out_days = ''
        tomorrow = Date.tomorrow
        5.times do |i|
            out_days << content_tag(:div, class: 'secondary_weather_container') do
                out_day = ''
                out_day << content_tag(:div, class: 'temp', id: "day#{i+1}") do
                    ('--&deg').html_safe
                end
                out_day << content_tag(:div, class: 'day') do
                    tomorrow.strftime("%A")
                end
                out_day.html_safe
            end
            tomorrow = tomorrow.tomorrow
        end
        out_days.html_safe
    end
end
