
import React from 'react'
import * as dateFns from "date-fns"; // Change to moment.js, it seems better for working with locales
//https://til.hashrocket.com/posts/cxd9yl95ip--get-beginning-and-end-of-week-with-momentjs
//https://stackoverflow.com/questions/17493309/how-do-i-change-the-language-of-moment-js

// https://blog.flowandform.agency/create-a-custom-calendar-in-react-3df1bfd0b728

var date = new Date();

var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);


function renderDays(year, month) {

  var firstDay = new Date(year, month-1, 1);

  const dateFormat = "dddd";
  const days = [];  
  let startDate = dateFns.startOfWeek(firstDay);
  console.log(`firstDay: ${firstDay}`)
  console.log(`startDate:${startDate}`)
  
  for (let i = 0; i < 7; i++) {
    console.log(dateFns.addDays(startDate, i))
    days.push(
      <div className="col col-center" key={i}>
        {dateFns.format(dateFns.addDays(startDate, i), dateFormat)}
      </div>
    );
  }

  return <div className="days row">{days}</div>;

} // renderDays

function renderCells() {

}

function CalendarMonth({year, month}) {

  return (
    <div className="month">
      <h2>Mes {month} del año {year}</h2>
      { renderDays(year, month) }
      { renderCells() }
    </div>

  )

}

export default CalendarMonth;