import $ from 'jquery'

const DAY_LENGTH = 6

const fetchWeather = async (pos) => {
    const {latitude, longitude} = pos.coords
    const weather = await fetch(`/weather?lat=${latitude}&lon=${longitude}`)
    const results = await weather.json()
    updateWithWeather(results)
}

// Find all days with ID selector
const findDays = () => {
    const days = []
    for(let i=0;i<DAY_LENGTH; i++){
        days[i] = $(`#day${i}`)[0]
    }
    return days
}

const updateWithWeather = results => {
    const days = findDays()
    for(let i = 0; i<DAY_LENGTH; i++){
        console.log(days[i])
        days[i].textContent = `${Math.round( results.forecast[i] )}\xB0`
    }
    $('#location')[0].textContent = results.location

}

const OnReady = () => {
    navigator.geolocation.getCurrentPosition(fetchWeather)
}
$(document).ready(OnReady)