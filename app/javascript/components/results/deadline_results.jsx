import React from "react";
import DeadlineCalendar from "./deadline_calendar";
import moment from 'moment'

function formatDeadline(deadline){
    return moment(deadline,'YYYY-MM-DD').format('dddd DD [de] MMMM [de] YYYY')
}

function arrayToTextEnumeration(array) {
    if(array.length==1) return array[0]
    
    let firstElements = array.slice(0,-1)
    let lastElements = array.slice(-1)
    
    return [firstElements.join(', ')].concat(lastElements).join(' y ')
}

function renderMissingHoliday(holiday){
    let txtYears = holiday.years.length > 1 ? 'años' : 'año'
    let text = `${holiday.territory}: ${txtYears} ${arrayToTextEnumeration(holiday.years)}`
    return (
    <li key={text}>
        {text}
    </li>
    )
}

function renderMissingHolidays(missingHolidays) {
    console.log(missingHolidays)
    if(!missingHolidays.length) return

    let missing = missingHolidays.map( (holiday) => renderMissingHoliday(holiday))

    return (
      <div className="alert alert-danger" role="alert">
        <p>
        <strong>Atención: </strong>
        no se dispone de datos de vacaciones para los siguientes territorios; 
        la fecha de vencimiento podría ser posterior a la fecha calculada:
        </p>
        <ul>
            {missing}
        </ul>
        
      </div>
    )
}

export default function DeadlineResults(props) {
    let results = props.results
    return (
        <React.Fragment>
            <h4>
            <span>Vencimiento: <strong>{formatDeadline(results.deadline)}</strong></span>
            </h4>
            {renderMissingHolidays(results.missing_holidays)}
            {/* Vacaciones:{JSON.stringify(results.holidays)}<br/> */}
            <DeadlineCalendar
                notification={results.notification}
                deadline={results.deadline}
                holidays={results.holidays}
            />
        </React.Fragment>
    );
}