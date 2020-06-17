import React from "react";
import style from './deadline_calendar_legend.module.scss'


function kindOrder(kind) {
    const order = [
        'country',
        'autonomous_community',
        'region',
        'island',
        'municipality',
        'local_entity',
    ]
    return order.indexOf(kind)
}

function compareKind(a,b) {
    return kindOrder(a) - kindOrder(b)
}

function unique(holidays) {

    let uniqueHolidays = Array.from(
        new Set(holidays.map(holiday => holiday.kind)))
            .map( kind => {
                return holidays.find(item => item.kind === kind)
            }
        )

    return uniqueHolidays
}

function sortedHolidays(holidays) {
    return holidays.sort( (a,b) => compareKind(a.kind,b.kind) )
}
    
function renderLegends(holidays, markStyles) {
    return (
        holidays.reduce( (acc, holiday) => 
            [...acc, renderLegendItem(holiday.territory, holiday.kind, markStyles)]
        , [])
    )
}

function renderLegendItem(territory, kind, markStyles) {
    return (
    <div className={style.row} key={territory}>
        <div className={style.color} style={markStyles[kind]}></div>
        <div className={style.legend}>{'Festivo en '+territory}</div>
    </div> 
    )
}

function Legend(props) {

    let sorted = unique(sortedHolidays(props.holidays))

    return (
        <div className=''>
            {renderLegends(sorted, props.markStyles)}
        </div>
    )
}

export default Legend