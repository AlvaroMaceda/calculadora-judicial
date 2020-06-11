import React from 'react'
import Month from './calendar_month'

// https://blog.flowandform.agency/create-a-custom-calendar-in-react-3df1bfd0b728

function renderMonths(year, months) {
  return months.map(month => <Month key={year+month} year={year} month={month}/>)
}

const lalala = `
Julio 2020       
lu ma mi ju vi sá do  
29 30  1  2  3  4  5  
 6  7  8  9 10 11 12  
13 14 15 16 17 18 19  
20 21 22 23 24 25 26  
27 28 29 30 31  
`

function Calendar({year, months}) {

  return (
    <React.Fragment>
      <pre>
      {lalala}      
      </pre>
      <h1>OLA K ASE</h1>
      { renderMonths(year, months) }
      <br/>
      {year}
    </React.Fragment>
  )

}


export default Calendar;