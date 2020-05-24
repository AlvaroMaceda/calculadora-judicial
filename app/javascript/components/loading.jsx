import React from "react";
import style from './loading.module.scss'

const Spinner = <div className={style.container}>
    <div className={"spinner-grow spinner-grow-sm " + style.loading_spinner}></div>
    <div className={"spinner-grow spinner-grow-sm " + style.loading_spinner}></div>
    <div className={"spinner-grow " + style.loading_spinner}></div>
    <div className={"spinner-grow spinner-grow-sm " + style.loading_spinner}></div>
    <div className={"spinner-grow spinner-grow-sm " + style.loading_spinner}></div>
</div>

export default function createLoading(WrappedComponent) {

    return function(props){
        if(props.loading == null) return '';

        return (
            <React.Fragment>
                { props.loading && Spinner}
                {!props.loading && <WrappedComponent {...props}/>}                        
            </React.Fragment>
        )
    }
        

}