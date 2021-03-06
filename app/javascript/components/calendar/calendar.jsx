import React from 'react'
import { Component } from 'react';
import ReactDOM from "react-dom";
import Month from './month'
import style from './calendar.module.scss'
import moment from 'moment'
import proptypes from './calendar.proptypes'

function measureElement(element) {
  const DOMNode = ReactDOM.findDOMNode(element);

  let style = getComputedStyle(DOMNode);
  let margin = {
    top: parseInt(style.marginTop) || 0,
    left: parseInt(style.marginLeft) || 0,
    bottom: parseInt(style.marginBottom) || 0,
    right: parseInt(style.marginRight) || 0
  }
  let padding = {
    top: parseInt(style.paddingTop) || 0,
    left: parseInt(style.paddingLeft) || 0,
    bottom: parseInt(style.paddingBottom) || 0,
    right: parseInt(style.paddingRight) || 0
  }
  return {
    // The item will occupy: offsetWidth + margin
    spaceOccupied: {
      width: DOMNode.offsetWidth + margin.left + margin.right,
      height: DOMNode.offsetHeight + margin.top + margin.bottom
    },
    // We will have available for content: clientWidth - padding
    availableForContent: {
      width: DOMNode.clientWidth - padding.left - padding.right,
      height: DOMNode.clientHeight - padding.top - padding.bottom
    }
  }
}

class Calendar extends Component {

  static defaultProps = {
    showDayNames: true,
    onlyMonthDays: false,
    markDays: {}
  }

  constructor(props){
    super(props)
    props.locale && moment.locale(props.locale)
    this.state = { 
      monthWidth: {width: '100%'}
    }
    this.currentMonthsPerRow = 0
    this.months = this.getMonthsToDraw(this.props.from, this.props.to)
  }

  updateDimensions() {
    this.containerSize = measureElement(this.container)
    this.monthSize = measureElement(this.monthRef)
    this.setMonthsContainerWidth(this.containerSize, this.monthSize)
  }

  setMonthsContainerWidth(containerSize, monthSize) {
    // console.log(`month per row:${monthsPerRow}`)
    // console.log('container size:', containerSize)
    // console.log('month size:', monthSize) 

    let monthsPerRow = this.monthsPerRow(containerSize.availableForContent.width, monthSize.spaceOccupied.width)


    if(monthsPerRow !== this.currentMonthsPerRow) {
      this.currentMonthsPerRow = monthsPerRow

      const JUST_IN_CASE=5;
      let monthContainerWidth = Math.min(monthsPerRow,this.months.length) * monthSize.spaceOccupied.width + JUST_IN_CASE 

      this.setState({
        ...this.state,
        monthWidth: {width: `${monthContainerWidth}px`}
      })
    }
  }

  componentDidMount() {
    this.updateDimensions();
    window.addEventListener("resize", this.updateDimensions.bind(this));
  }

  componentWillUnmount() {
    window.removeEventListener("resize", this.updateDimensions.bind(this));
  }

  componentDidUpdate(){
    console.log('componentDidUpdate')
    this.updateDimensions();
  }

  maxMonthsPerRow() {
    return Math.floor(
      this.containerSize.availableForContent.width / this.monthSize.spaceOccupied.width
      )
  }

  monthsPerRow(containerWidth, monthWidth) {
    // console.log(`container width: ${containerWidth} month width: ${monthWidth}`)

    const maxMonthsPerRow = Math.floor(containerWidth / monthWidth)
    /*
    The idea is to place the months in a "pretty" layout. For example, if 
    we have 5 monts (1 2 3 4 5)
    
    If max per row = 3 we should place:
    1 2 3
    4 5

    this will be a ugly layout:
    1 2
    3 4
    5

    If max per row = 4 we should place:
    1 2 3
    4 5

    this will be a ugly layout:
    1 2 3 4
    5

    If max per row = 5 we should place all in the same row
    1 2 3 4 5

    */
   /*
    maximo que caben: max
    desde 1 hasta max: seleccionar el r que deje menos hueco, siendo el hueco: (max - (n % r)) % n (el último %n es porque, si caben justos, no hay hueco)
    El 1 solo como última opción
   */
    // Return the max until we have the algorithm
    return maxMonthsPerRow
  }

  getMonthsToDraw(from, to) {

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

  renderMonths(months) {
    return months.map(month => {
      // We should filter here highlights to pass only the highlights for that month
      return (<Month key={`${month.year}${month.month}`}
             year={month.year} 
             month={month.month}
             ref={r => this.monthRef = r}
             showDayNames={this.props.showDayNames}
             markStyles={this.props.markStyles}
             markDays={this.props.markDays}
             onlyMonthDays={this.props.onlyMonthDays}
      />)
    })
  }

  render() {
    

    return (
      <div className={style.calendar}
           ref={element => {this.container = element;}}
      >
        <div className={style.monthsContainer} style={this.state.monthWidth}>
          { this.renderMonths(this.months) }
        </div>
      </div>
    )
  }

}
Calendar.propTypes = proptypes

export default Calendar;