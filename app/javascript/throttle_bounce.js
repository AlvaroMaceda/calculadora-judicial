// ---------------------------------------------------
// Para probar
// ---------------------------------------------------
let f = throttle( (e) => console.log(e) , 1000)


function formatDate(d) {
    return d.getMinutes() + ':' + d.getSeconds() + "." + d.getMilliseconds()
}
let f = (e) => console.log(e)
let counter = 1
let createTick = () => {
    let call_time = new Date()
    let call_counter = counter++
    return function tick() {
        f('call time:'+formatDate(call_time) + 
          ' counter:' + call_counter +
          ' now:' + formatDate(new Date()))
        timeout = setTimeout(createTick(),300)
    }
}
let timeout = setTimeout(createTick(),300)


let tick = () => {
    f(counter++)
    timeout = setTimeout(tick,300)
}
// Para cancelar:
clearTimeout(timeout)
// ---------------------------------------------------


// https://medium.com/walkme-engineering/debounce-and-throttle-in-real-life-scenarios-1cc7e2e38c68
// as long as it continues to be invoked, raise on every interval
function throttle (func, interval) {
    let timeout = false
    let last_call_args = null
    return function() {
        var context = this, args = arguments;
        var later = function () {
                func.apply(context, last_call_args)
                last_call_args = null
                timeout = false;
            };
        last_call_args = args
        if (!timeout) {
            func.apply(context, args)
            timeout = true;
            setTimeout(later, interval)
        }
    }
}
  
  // as long as it continues to be invoked, it will not be triggered
  function debounce (func, interval) {
    var timeout;
    return function () {
      var context = this, args = arguments;
      var later = function () {
        timeout = null;
        func.apply(context, args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, interval || 200);
    }
  }