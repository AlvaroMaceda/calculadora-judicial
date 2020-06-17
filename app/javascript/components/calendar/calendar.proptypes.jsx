import PropTypes from 'prop-types';

const props = {

    /*
    Start date for the calendar.
    You can pass:
        - An string in YYYY-MM format (ie, '2020-01)
        - A moment object
        - Something which can be converted to a moment object with moment(from,'YYYY-MM)

    You don't need to speficy a day, it will take only the year and the month
    */
    from: PropTypes.any.isRequired,

    /*
    End date for the calendar. Same rules as 'from' property
    */
    to: PropTypes.any.isRequired,

    /*
    Locale to use. It will use default locale if not provided
    */
    locale: PropTypes.string,

    /*
    Marks to be applied to certain days of the month.
    Object keys are the days to be marked; 
    Values are the styles to be applied:
        - You can speficy an inline style as an object 
        - If you pass a string, it will be applied markStyle corresponding style as inline style

    Note that you can't use 'real' classes because classes defined into Month component
    will be more specific and they will overwrite your class properties, so you will have
    to use !important in each property.

    Example:
    <Month
        markDays= {{
            '2020-12-07': 'markStyleToApply',
            '2020-12-25': {background: 'salmon', color: 'white'},
        }}
    />

    If you pass days which dont pertain to the month, they will be ignored
    */
    markdays: PropTypes.object,

    /*
    Defines "styles" to be applied to the marks, so you don't have to 
    rewrite css properties for each mark. 

    <Calendar
        from='...'
        to='...'
        markStyles={{
            style1: { backgroundColor: 'red', fontWeigth: 700},
            style2: { color: 'purple'}
        }}
        markDays={{
            '2020-12-07': 'style1',
            '2020-12-25': 'style2',
        }}
    */
    markStyles: PropTypes.object,

    /*
    Indicates whether or not the component should display the names of the days of the week.
    ¿LOCALIZED?
    Defaults to true
    */
    showDayNames: PropTypes.bool,

    /*
    Indicates whether or not the component should display only the days corresponding to this month
    (dont show the final days of previous month and the firsts of next month if
    the month does not start or finish on the first day of weeek)

    Defaults to false
    */
    onlyMonthDays: PropTypes.bool,

}


export default props