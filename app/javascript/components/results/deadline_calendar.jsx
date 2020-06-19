import React from "react";
import Calendar from '../calendar/calendar'
import moment from 'moment'
import Legend from './deadline_calendar_legend'

const TERM_BACKGROUND = '#eac23e'
const NATIONAL_HOLIDAY_BACKGROUND = '#bb3a4c'
const AC_HOLIDAY_BACKGROUND = '#92bb3a'
const REGIONAL_HOLIDAY_BACKGROUND = '#3a8a78'
const MUNICIPALITY_HOLIDAY_BACKGROUND = '#3a9bbb'
const LOCAL_ENTITY_HOLIDAY_BACKGROUND = '#3a9bbb'

const holidayStyles = {

  country: {
    background: NATIONAL_HOLIDAY_BACKGROUND,
    color: 'white'
  },
  autonomous_community: {
    background: AC_HOLIDAY_BACKGROUND,
    color: 'white'
  },
  region: {
    background: REGIONAL_HOLIDAY_BACKGROUND,
    color: 'white'
  },
  island: {
    background: REGIONAL_HOLIDAY_BACKGROUND,
    color: 'white'
  },
  municipality: {
    background: MUNICIPALITY_HOLIDAY_BACKGROUND,
    color: 'white'
  },
  local_entity: {
    background: LOCAL_ENTITY_HOLIDAY_BACKGROUND,
    color: 'white'
  }
}

const markStyles = {
  weekend: {
    background: TERM_BACKGROUND, color: 'red'
  },

  term: {
    background: TERM_BACKGROUND, color: 'white'
  },
  termStart: {
    // background: TERM_BACKGROUND, color: 'white',
    border: '2px solid #0075a0',
    // borderLeft: '5px solid #0075a0',
  },
  termEnd: {
    background: TERM_BACKGROUND, color: 'white',
    border: '2px solid red',
    // borderRight: '5px solid red'
    // borderRight: '5px solid black'
  },

  ...holidayStyles

}

// Duplicated function
function isWeekend(day) {
  const SATURDAY = 6
  const SUNDAY = 7
  return day.isoWeekday() == SATURDAY || day.isoWeekday() == SUNDAY
}

function getTermMarks(start, end) {
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

function getHolidaysMarks(holidays) {

  let marks = {}, style

  holidays.forEach( (holiday) => {
    style = holiday.kind
    marks[moment(holiday.date).format('YYYY-MM-DD')] = style
  })

  return marks
}

function getWeekendMarks(marks) {
  const filtered = Object.keys(marks)
    .filter( key => isWeekend(moment(key)) )
    .reduce((obj, key) => {
      obj[key] = 'weekend'
      return obj
      }, {})
  return filtered
}

function DeadlineCalendar(props) {

  let termMarks = getTermMarks(props.notification, props.deadline)
  let weekendMarks = getWeekendMarks(termMarks)
  let holidaysMarks = getHolidaysMarks(props.holidays)
  

  // Order is relevant: lasts in list will overwrite firsts
  let marks = {
    ...termMarks,
    ...weekendMarks,
    ...holidaysMarks
  }
  // console.log('termMarks:',termMarks)
  // console.log('termWeekends:',termWeekends)
  // console.log('holidays:',termHolidays)
  // console.log('marks:',marks)

  return(
    <div>
      <Calendar
        locale='es'
        from={props.notification}
        to={props.deadline}
        showDayNames={false}
        onlyMonthDays={true}
        markStyles={markStyles}
        markDays={marks}
      />
      <Legend
        holidays={props.holidays}
        markStyles={markStyles}
      />
    </div>
  )

}

export default DeadlineCalendar