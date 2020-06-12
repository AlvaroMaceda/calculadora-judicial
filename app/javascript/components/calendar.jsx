import React from 'react'
import Month from './calendar_month'
import style from './calendar.module.scss'
import moment from 'moment'
moment.locale('es');

// https://blog.flowandform.agency/create-a-custom-calendar-in-react-3df1bfd0b728

function getMonthsToDraw(from, to) {

  let months = []

  const fromDate = moment(from,"YYYY-MM")
  const toDate = moment(to,"YYYY-MM")

  let currentDate = moment(fromDate)
  while(currentDate <= toDate) {
    months.push({
      year: currentDate.year(),
      month: currentDate.month()+1 // Month expects the "human" month number
    })
    currentDate.add(1,'month')
  }

  return months
}

function renderMonths(months) {
  return months.map(month => 
    <Month key={`${month.year}${month.month}`}
           year={month.year} 
           month={month.month}/>
  )
}

function Calendar({from, to}) {

  let months = getMonthsToDraw(from, to)

  return (
    <div className={style.calendar}>
      { renderMonths(months) }
    </div>
  )

}

export default Calendar;