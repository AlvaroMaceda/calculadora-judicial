import React from "react";
import DeadlineCalendar from "./deadline_calendar";
import moment from 'moment'

function formatDeadline(deadline){
    return moment(deadline,'YYYY-MM-DD').format('dddd DD [de] MMMM [de] YYYY')
}

// TO-DO: change the format of holidaysmissiong
function renderMissingHoliday(holiday){
    console.log(holiday)
    let text = `${holiday.territory || ''}${holiday.autonomous_community || ''}${holiday.country || ''} ${holiday.year}`
    return (
    <li key={text}>
        {text}
    </li>
    )
}

function renderMissingHolidays(missingHolidays) {
    console.log(missingHolidays)
    // if(!this.state.requestError) return

    let missing = missingHolidays.map( (holiday) => renderMissingHoliday(holiday))

    return (
      <div className="alert alert-danger" role="alert">
        <p>
        <strong>Atención: </strong>
        no se dispone de datos de vacaciones para los siguientes territorios, 
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
            {/* <h3>Estos son los resultados del cálculo:</h3> */}
            {/* Notificado: {results.notification}<br/>
            Días:{results.days}<br/> */}
            <span>Vencimiento:
            <strong>{formatDeadline(results.deadline)}</strong></span>
            <h4></h4>
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