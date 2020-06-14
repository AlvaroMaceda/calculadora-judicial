import React from "react";
import DeadlineCalendar from "./deadline_results_calendar";

export default function DeadlineResults(props) {
    let results = props.results
    return (
        <React.Fragment>
            <h3>Estos son los resultados del cálculo:</h3>
            Notificado: {results.notification}<br/>
            Días:{results.days}<br/>
            Vencimiento:{results.deadline}<br/>
            {/* Vacaciones:{JSON.stringify(results.holidays)}<br/> */}
            <DeadlineCalendar
                notification={results.notification}
                deadline={results.deadline}
                holidays={results.holidays}
            />
        </React.Fragment>
    );
}