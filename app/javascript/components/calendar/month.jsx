
import React, { Component } from 'react'
import moment from 'moment'
import classNames from 'classnames'
import style from './month.module.scss'
import proptypes from './month.proptypes'

const NO_CLASS = ''
const NO_STYLE = {}

// Duplicated function
function isWeekend(day) {
  const SATURDAY = 6
  const SUNDAY = 7
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

  static defaultProps = {
    showDayNames: true,
    onlyMonthDays: false,
    markDays: {},
    markStyles: {},
  }

  constructor(props){
    super(props)

    props.locale && moment.locale(props.locale)

    this.disabledStyle = props.onlyMonthDays ? style.hidden : style.disabled 
    this.month = moment([
      parseInt(props.year),
      parseInt(props.month-1),
      1])
    this.markDays = props.markDays
  }

  getMarkStyle(styleName){
    return this.props.markStyles[styleName] || {}
  }
  
  getHighlightedStyle(day) {
    let style = this.markDays[day.format('YYYY-MM-DD')]
    if(!style) return {}

    return isString(style) ? 
        this.getMarkStyle(style) :
        style
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
    if(!day.isSame(this.month,'month')) return this.disabledStyle
    if(isWeekend(day)) return style.weekend
    return NO_CLASS
  }

  renderMonthLabel() {
    const monthLabel = `${this.month.format('MMMM')} ${this.month.format('Y')}`
    return <div className={style.header}>{monthLabel}</div>
  }

  renderDayNames() {

    if(!this.props.showDayNames) return ''

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

  renderDay(day) {
    return (
      <div
        className={ classNames(style.col, style.cell, this.dayClass(day)) }
        style={ this.dayStyle(day) }
        key={ day }
      >
        <span className={style.number}>{day.format('D')}</span>
      </div>
    )
  }

  renderWeek(startOfWeek) {
    let days = []
    let day = moment(startOfWeek)

    for (let i = 0; i < 7; i++) {
      days.push(this.renderDay(day))
      day.add(1, 'd')
    }
    return (
      <div className={style.row} key={day}>
        {days}
      </div>
    )
  }

  renderCells() {
    const startDate = this.firstDayToRender()
    const endDate = this.lastDayToRender()
  
    let day = startDate
    const rows = []

    while (day <= endDate) {
      rows.push(this.renderWeek(day))
      day.add(7, 'd')
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
CalendarMonth.propTypes = proptypes

export default CalendarMonth