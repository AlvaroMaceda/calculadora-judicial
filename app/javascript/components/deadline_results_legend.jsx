import React from "react";
import style from './deadline_results_legend.module.scss'


function Legend(props) {

    return (
        <div className=''>
            {/* {JSON.stringify(props.holidays)}
            {JSON.stringify(props.markStyles)} */}

            <div className={style.row}>
                <div className={style.color} style={props.markStyles['countryHoliday']}></div>
                <div className={style.legend}>Festivos nacionales</div>
            </div>
            <div className={style.row}>
                <div className={style.color} style={props.markStyles['autonomous_communityHoliday']}></div>
                <div className={style.legend}>Festivos de la comunidad autónoma</div>
            </div>
            <div className={style.row}>
                <div className={style.color} style={props.markStyles['regionHoliday']}></div>
                <div className={style.legend}>Festivos regionales</div>
            </div>
            <div className={style.row}>
                <div className={style.color} style={props.markStyles['municipalityHoliday']}></div>
                <div className={style.legend}>Festivos municipales</div>
            </div>
        </div>
    )
}

export default Legend