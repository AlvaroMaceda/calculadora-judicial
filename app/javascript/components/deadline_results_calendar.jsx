import React from "react";
import Calendar from './calendar'
import moment from 'moment'
import style from './deadline_results_calendar.module.scss'

const markStyles = {
  weekend: {
    background: 'red', color: 'white'
  },
  term: {
    background: 'orange', color: 'blue'
  },
  termStart: {
    background: 'orange', color: 'blue',
    borderLeft: '5px solid black'
  },
  termEnd: {
    background: 'orange', color: 'blue',
    borderRight: '5px solid black'
  }
}

// Duplicated function
function isWeekend(day) {
  const SATURDAY = 6
  const SUNDAY = 7
  return day.isoWeekday() == SATURDAY || day.isoWeekday() == SUNDAY
}

function termDays(start, end) {
  const startDay = moment(start)
  const endDay = moment(end)
  
  let days = {}
  let current = moment(startDay)

  while( current <= endDay ) {
    
    let appliedStyle = style.term
    if(current.isSame(startDay,'day')) appliedStyle = style.termStart // style = 'termStart'
    if(current.isSame(endDay,'day')) appliedStyle = style.termEnd

    days[current.format('YYYY-MM-DD')] = appliedStyle
    current.add(1,'day')
  }

  return days
}

function markWeekends(marks) {
  // TO-DO: this is unintelligible. Refactor.
  return Object.fromEntries(
    Object.entries(marks).filter( 
      ([key, value] ) => {
        return isWeekend(moment(key))
      }).map( ([key,value]) => [key,'weekend'] )
  );
}

function DeadlineCalendar(props) {

  let termMarks = termDays(props.notification, props.deadline)
  let termWeekends = markWeekends(termMarks)
  let termHolidays = {} //TO-DO
  

  // Order is relevant: last in list will overwriter firsts
  let marks = {
    ...termMarks,
    ...termWeekends,
    ...termHolidays
  }
  console.log('termMarks:',termMarks)
  console.log('termWeekends:',termWeekends)
  console.log('marks:',marks)

  return(
    <Calendar
      locale='es'
      from={props.notification}
      to={props.deadline}
      showDayNames={false}
      // markStyles={markStyles}
      markDays= {{
        '2020-12-07': 'tee',
        '2020-12-25': {background: 'salmon', color: 'white'},
        '2021-01-01': {background: 'teal', color: 'red'},
        '2021-01-06': {background: 'yellow', color: 'purple'}
      }}
      markDays={marks}
      // markDays= {[
      //   {'2020-12-07': 'tee'},
      //   {'2020-12-25': {background: 'salmon', color: 'white'}},
      //   {'2021-01-01': {background: 'teal', color: 'red'}},
      //   {'2021-01-06': {background: 'yellow', color: 'purple'}}
      // ]}
    />
  )

}

export default DeadlineCalendar