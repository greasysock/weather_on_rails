import $ from 'jquery'

const fetchWeather = async (pos) => {
    const {latitude, longitude} = pos.coords
    const weather = await fetch(`/weather?lat=${latitude}&lon=${longitude}`)
    const results = await weather.json()
    console.log(results)
}

const OnReady = () => {
    navigator.geolocation.getCurrentPosition(fetchWeather)
}
$(document).ready(OnReady)