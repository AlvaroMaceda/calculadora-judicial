
import React, { Component } from 'react'
import moment from 'moment'
import classNames from 'classnames'
import style from './calendar_month.module.scss'
//https://til.hashrocket.com/posts/cxd9yl95ip--get-beginning-and-end-of-week-with-momentjs
//https://stackoverflow.com/questions/17493309/how-do-i-change-the-language-of-moment-js

// https://blog.flowandform.agency/create-a-custom-calendar-in-react-3df1bfd0b728

moment.locale('es')


// I don't like this, it abreviates as "lu ma mi ju vi sá do"
function renderDayNames_i18n() {

  const dateFormat = "dd"
  const days = [];  
  const currentDate = moment().startOf('week')
  
  for (let i = 0; i < 7; i++) {
    days.push(
      <div className="col col-center" key={i}>
        { currentDate.format(dateFormat) }
      </div>
    )
    currentDate.add(1, 'd')
  }

  return <div className="days row">{days}</div>
} // renderDayNames_i18n


function renderDayNames() {

  const days = ['L','M','X','J','V','S','D']
  let cells = []

  days.forEach( (day, i) => {
    cells.push(
      <div className={classNames(style.col,style.col_center)} key={i}>
        { day }
      </div>
    )
  })

  return <div className={classNames(style.days,style.row)}>{cells}</div>
} // renderDayNames

function renderCells(year, month) {
  const monthStart = moment([year,month,1])
  const monthEnd = moment(monthStart).endOf('month')

  const startDate = moment(monthStart).startOf('week')
  const endDate = moment(monthEnd).endOf('week')

  const rows = []

  let days = []
  let day = startDate

  while (day <= endDate) {
    for (let i = 0; i < 7; i++) {
      days.push(
        <div
          className={classNames(style.col,style.cell,
              !day.isSame(monthStart,'month') ? style.disabled : style.enabled
          )}
          key={day}
        >
          <span className={style.number}>{day.format('D')}</span>
        </div>
      )
      day.add(1, 'd')
    }
    rows.push(
      <div className={style.row} key={day}>
        {days}
      </div>
    )
    days = []
  }
  return <div className={style.body}>{rows}</div>
} // renderCells

class CalendarMonth extends Component {

  render(){
    let year = this.props.year
    let month = this.props.month 
    month = month -1 // Adjust to javascript months

    const monthDate = moment([year,month,1])
    const monthLabel = `${monthDate.format('MMMM')} ${monthDate.format('Y')}`
  
    return (
      <div className={style.calendar}>
        <div className={style.header}>{monthLabel}</div>
        { renderDayNames() }
        { renderCells(year, month) }
      </div>
  
    )
  }

}

export default CalendarMonth