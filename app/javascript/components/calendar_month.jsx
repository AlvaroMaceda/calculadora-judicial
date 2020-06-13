
import React, { Component } from 'react'
import moment from 'moment'
import classNames from 'classnames'
import style from './calendar_month.module.scss'
//https://til.hashrocket.com/posts/cxd9yl95ip--get-beginning-and-end-of-week-with-momentjs
//https://stackoverflow.com/questions/17493309/how-do-i-change-the-language-of-moment-js

// https://blog.flowandform.agency/create-a-custom-calendar-in-react-3df1bfd0b728

moment.locale('es')

const SATURDAY = 6
const SUNDAY = 7
const NO_CLASS = ''
const NO_STYLE = {}

function isWeekend(day) {
  return day.isoWeekday() == SATURDAY || day.isoWeekday() == SUNDAY
}

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

function isString(x) {
  return Object.prototype.toString.call(x) == '[object String]';
}

// Can't be a functional component because we need a ref to the content
// to compute how many months we will draw in each row
class CalendarMonth extends Component {

  constructor(props){
    super(props)
    this.month = moment([this.props.year,this.props.month-1,1])
    // Here: adjust markdays index
  }

  getHighlightedStyle(day) {
    // TO-DO: define methods to extract the relevant data for an highlighted day
    // (don't use Object.keys and Object.entries)
    let highlightprops = this.props.markDays.filter(      
      (highlighted) => {
        let highlightedDay = moment(Object.keys(highlighted)[0])
        return highlightedDay.isSame(day,'day')
      }
    )
    let computed = {}
    if(highlightprops.length > 0) {
      // This is a ugly form of obtaining the value of first key
      computed = Object.entries(highlightprops[0])[0][1]
      // Here we should lookup markStyles
      if(isString(computed)) computed = {color: 'yellow'}
    }
    return computed
  }

  firstDayToRender(){
    // Start of week of first week of month
    return moment(this.month).startOf('week')
  }

  lastDayToRender() {
    // End of week of last week of month
    return moment(this.month).endOf('month').endOf('week')
  }

  dayStyle(day) {
    if(!day.isSame(this.month,'month')) return NO_STYLE
    return this.getHighlightedStyle(day)
  }

  dayClass(day) {
    if(!day.isSame(this.month,'month')) return style.disabled
    if(isWeekend(day)) return style.weekend
    return NO_CLASS
  }

  renderMonthLabel() {
    const monthLabel = `${this.month.format('MMMM')} ${this.month.format('Y')}`
    return <div className={style.header}>{monthLabel}</div>
  }

  renderDayNames() {

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

  renderCells() {
    const startDate = this.firstDayToRender()
    const endDate = this.lastDayToRender() 
  
    const rows = []
  
    let days = []
    let day = startDate
  
    while (day <= endDate) {
      for (let i = 0; i < 7; i++) {
        days.push(
          <div
            className={ classNames(style.col, style.cell, this.dayClass(day)) }
            style={ this.dayStyle(day) }
            key={ day }
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

  render(){
    return (
      <div className={style.month}>
        { this.renderMonthLabel() }
        { this.renderDayNames() }
        { this.renderCells() }
      </div>
    )
  }

}

export default CalendarMonth