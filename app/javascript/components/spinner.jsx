import React from "react";

const Spinner = <div>
    banana
</div>

export default function createSpinner(WrappedComponent) {

    return function(props){
        console.debug('Spinner')
        console.debug(props)
        return (
            <React.Fragment>
                { props.loading && Spinner}
                {!props.loading && <WrappedComponent {...props}/>}                        
            </React.Fragment>
        )
    }
        

}

// {!loading && <WrappedComponent {...props} />}