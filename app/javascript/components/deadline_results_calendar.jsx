import React from "react";
import Calendar from './calendar'
import moment from 'moment'

const TERM_BACKGROUND = '#eac23e'
// const TERM_BACKGROUND = '#skyblue'
const markStyles = {
  weekend: {
    background: TERM_BACKGROUND, color: 'red'
  },
  term: {
    background: TERM_BACKGROUND, color: 'white'
  },
  termStart: {
    background: TERM_BACKGROUND, color: 'white',
    border: '2px solid #0075a0',
    borderLeft: '5px solid #0075a0',
  },
  termEnd: {
    background: TERM_BACKGROUND, color: 'white',
    border: '2px solid red',
    borderRight: '5px solid red'
    // borderRight: '5px solid black'
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
    
    let style = 'term'
    if(current.isSame(startDay,'day')) style = 'termStart'
    if(current.isSame(endDay,'day')) style = 'termEnd'

    days[current.format('YYYY-MM-DD')] = style
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
      onlyMonthDays={true}
      markStyles={markStyles}
      // markDays= {{
      //   '2020-12-07': 'tee',
      //   '2020-12-25': {background: 'salmon', color: 'white'},
      //   '2021-01-01': {background: 'teal', color: 'red'},
      //   '2021-01-06': {background: 'yellow', color: 'purple'}
      // }}
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