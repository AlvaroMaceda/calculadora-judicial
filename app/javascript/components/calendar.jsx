import React from 'react'
import Month from './calendar_month'

// https://blog.flowandform.agency/create-a-custom-calendar-in-react-3df1bfd0b728

function renderMonths(year, months) {
  return months.map(month => <Month key={year+month} year={year} month={month}/>)
}

function Calendar({year, months}) {

  return (
    <React.Fragment>
      <h1>OLA K ASE</h1>
      { renderMonths(year, months) }
      <br/>
      {year}
    </React.Fragment>
  )

}


export default Calendar;