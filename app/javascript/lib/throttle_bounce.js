// Based on https://medium.com/walkme-engineering/debounce-and-throttle-in-real-life-scenarios-1cc7e2e38c68

function throttle (func, interval) {

    let must_wait = false
    let pending_call = null

    return function() {
        // We must store the context because we don't know if the function
        // will be executed later
        let context = this

        let wait_and_check = function () {
                // Check every throttle interval
                
                if(pending_call) {
                    // If a pending call is waiting, call it now
                    // Then we must wait another interval and check if there are
                    // new calls awaiting execution
                    func.apply(context, pending_call)
                    pending_call = null
                    setTimeout(wait_and_check,interval)
                } else {
                  // There are no more pending calls
                  // Next call should not wait
                  must_wait = false
                }
            };
      
        if (!must_wait) {
            // It has been more than 0interval' milliseconds since last call
            func.apply(context, arguments)
            // Next call must wait. We will check if there are pending calls
            // after 'interval' milliseconds
            must_wait = true;
            setTimeout(wait_and_check, interval)
        } else {
            // This call must wait. Store it and the timeout will launch it.
            // It there was a previous call waiting, is deleted
            pending_call = arguments
        }
    }
}
  

function debounce (func, interval) {

    let timeout;
    
    return function () {
        let context = this
        let args = arguments;
        var later = function () {
              timeout = null;
              func.apply(context, args);
          };
        clearTimeout(timeout);
        timeout = setTimeout(later, interval || 200);
    }
}

export { throttle, debounce }