import React from "react";

export default function DeadlineResults(props) {
    let results = props.results
    console.log(`deadlineResults-results:${props.results}`)
    return (
        <React.Fragment>
            <h3>Estos son los resultados del cálculo:</h3>
            Notificado: {results.notification}<br/>
            Días:{results.days}<br/>
            Vencimiento:{results.deadline}<br/>
        </React.Fragment>
    );
}