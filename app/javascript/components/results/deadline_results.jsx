import React from "react";
import DeadlineCalendar from "./deadline_results_calendar";
import moment from 'moment'

function formatDeadline(deadline){
    return moment(deadline,'YYYY-MM-DD').format('dddd DD [de] MMMM [de] YYYY')
}

export default function DeadlineResults(props) {
    let results = props.results
    return (
        <React.Fragment>
            {/* <h3>Estos son los resultados del cálculo:</h3> */}
            {/* Notificado: {results.notification}<br/>
            Días:{results.days}<br/> */}
            <span>Vencimiento: </span>
            <span>{formatDeadline(results.deadline)}</span>            
            <h4></h4>
            {/* Vacaciones:{JSON.stringify(results.holidays)}<br/> */}
            <DeadlineCalendar
                notification={results.notification}
                deadline={results.deadline}
                holidays={results.holidays}
            />
        </React.Fragment>
    );
}