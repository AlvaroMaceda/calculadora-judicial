import PropTypes from 'prop-types';

const props = {

    /*
     Year to show. You can pass whatever thing that can be converted to int with parseInt
    */
    year: PropTypes.any.isRequired,
    
    /*
    Year to show. You can pass whatever thing that can be converted to int with parseInt
    The component expects the month in "human mode": january is 1, february is 2...
    */
    month: PropTypes.any.isRequired,
    
    /*
    Locale to use. It will use default locale if not provided
    */
    locale: PropTypes.string,

    /*
    Marks to be applied to certain days of the month.
    See Calendar component for more information
    If you pass days which dont pertain to the month, they will be ignored
    */
    markdays: PropTypes.any,

    /*
    Defines "styles" to be applied to the marks
    See Calendar component for more information
    */
    markStyles: PropTypes.object,

    /*
    Indicates whether or not the component should display the names of the days of the week.
    See Calendar component for more information
    */
    showDayNames: PropTypes.bool,

    /*
    Indicates whether or not the component should display only the days corresponding to this month
    See Calendar component for more information
    */
    onlyMonthDays: PropTypes.bool,
}


export default props