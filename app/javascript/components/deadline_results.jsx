import React from "react";

export default function DeadlineResults(props) {
    return (
        <React.Fragment>
            Estos son los resultados del cálculo:
            {props.results}
        </React.Fragment>
    );
}