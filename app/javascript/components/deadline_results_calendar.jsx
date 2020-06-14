import React from "react";
import Calendar from './calendar'
import moment from 'moment'

const TERM_BACKGROUND = '#eac23e'
// const TERM_BACKGROUND = '#skyblue'
const NATIONAL_HOLIDAY_BACKGROUND = '#bb3a4c'
const AC_HOLIDAY_BACKGROUND = '#92bb3a'
const MUNICIPALITY_HOLIDAY_BACKGROUND = '#3a9bbb'

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
  },

  countryHoliday: {
    background: NATIONAL_HOLIDAY_BACKGROUND,
    color: 'white'
  },
  autonomous_communityHoliday: {
    background: AC_HOLIDAY_BACKGROUND,
    color: 'white'
  },
  regionHoliday: {
    background: AC_HOLIDAY_BACKGROUND,
    color: 'white'
  },
  municipalityHoliday: {
    background: MUNICIPALITY_HOLIDAY_BACKGROUND,
    color: 'white'
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

function styleForKind(kind) {
  switch(kind) {
    case 'country':
    case 'municipality':
    case 'autonomous_community':
      return kind + 'Holiday'
    case 'region':
    case 'island':
      return 'regionHoliday'
    default:
      console.log('Holiday type not found:'+kind)
      return ''
  }
}

function holidaysMarks(holidays) {

  let marks = {}, style

  holidays.forEach( (holiday) => {
    style = styleForKind(holiday.kind)
    marks[moment(holiday.date).format('YYYY-MM-DD')] = style
  })

  return marks
}

function weekendMarks(marks) {
  const filtered = Object.keys(marks)
    .filter( key => isWeekend(moment(key)) )
    .reduce((obj, key) => {
      obj[key] = 'weekend'
      return obj
      }, {})
  return filtered
}

function DeadlineCalendar(props) {

  let termMarks = termDays(props.notification, props.deadline)
  let termWeekends = weekendMarks(termMarks)
  let termHolidays = holidaysMarks(props.holidays)
  

  // Order is relevant: lasts in list will overwrite firsts
  let marks = {
    ...termMarks,
    ...termWeekends,
    ...termHolidays
  }
  // console.log('termMarks:',termMarks)
  // console.log('termWeekends:',termWeekends)
  // console.log('holidays:',termHolidays)
  // console.log('marks:',marks)

  return(
    <React.Fragment>
      <Calendar
        locale='es'
        from={props.notification}
        to={props.deadline}
        showDayNames={false}
        onlyMonthDays={true}
        markStyles={markStyles}
        markDays={marks}
      />
    </React.Fragment>
  )

}

export default DeadlineCalendar