import React from 'react'
import Month from './calendar_month'
import style from './calendar.module.scss'

// https://blog.flowandform.agency/create-a-custom-calendar-in-react-3df1bfd0b728

function renderMonths(year, months) {
  return months.map(month => <Month key={year+month} year={year} month={month}/>)
}

function Calendar({year, months}) {

  return (
    <div class={style.calendar}>
      { renderMonths(year, months) }
    </div>
  )

}


export default Calendar;