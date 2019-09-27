import $ from 'jquery'

const DAY_LENGTH = 6

const DAYS = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
]

const fetchWeather = async (pos) => {
    const {latitude, longitude} = pos.coords
    const weather = await fetch(`/weather?lat=${latitude}&lon=${longitude}`)
    const results = await weather.json()
    updateWithWeather(results)
}

// Find all day temp spots with ID selector
const findDayTemps = () => {
    const days = []
    for(let i=0;i<DAY_LENGTH; i++){
        days[i] = $(`#day-temp${i}`)[0]
    }
    return days
}

// Find all day names and assign correct timezone day names
const assignDayNameToDays = () => {
    // Loop over forecast length minus one because current day is not included
    const currentDay = new Date()
    for(let i=0; i<DAY_LENGTH-1; i++){
        currentDay.setDate(currentDay.getDate()+1)
        $(`#day${i}`)[0].textContent = DAYS[currentDay.getDay()]
    }
}

const updateWithWeather = results => {
    const days = findDayTemps()
    for(let i = 0; i<DAY_LENGTH; i++){
        days[i].textContent = `${Math.round( results.forecast[i] )}\xB0`
    }
    $('#location')[0].textContent = results.location

}

const OnReady = () => {
    assignDayNameToDays()
    navigator.geolocation.getCurrentPosition(fetchWeather)
}
$(document).ready(OnReady)