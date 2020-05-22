// ---------------------------------------------------
// Para probar
// ---------------------------------------------------

// location.reload();

// let f, counter, createTick, timeout

// // f = (e) => console.log(e)
// f = throttle( (e) => console.log(e) , 3000)
// counter = 1
// createTick = () => {
//     let call_time = new Date()
//     let call_counter = counter++
//     return function tick() {
//         f('call time:'+formatDate(call_time) + 
//           ' counter:' + call_counter +
//           ' now:' + formatDate(new Date()))
//         timeout = setTimeout(createTick(),1400)
//     }
// }
// timeout = setTimeout(createTick(),1400)


// // let tick = () => {
// //     f(counter++)
// //     timeout = setTimeout(tick,300)
// // }
// // Para cancelar:
// clearTimeout(timeout)
// ---------------------------------------------------

function formatDate(d) {
      return d.getMinutes() + ':' + d.getSeconds() + "." + d.getMilliseconds()
}


// as long as it continues to be invoked, raise on every interval
// THIS FUNCTION FAILS, because the last invocation is never called
function throttle (func, interval) {
  var timeout;
  return function() {
    var context = this, args = arguments;
    var later = function () {
      timeout = false;
    };
    if (!timeout) {
      func.apply(context, args)
      timeout = true;
      setTimeout(later, interval)
    }
  }
}

// https://medium.com/walkme-engineering/debounce-and-throttle-in-real-life-scenarios-1cc7e2e38c68
// as long as it continues to be invoked, raise on every interval
function throttle2 (func, interval) {
    let timeout = false
    let last_call_args = null
    return function() {
        var context = this, args = arguments;
        var later = function () {
                // func.apply(context, last_call_args)
                // last_call_args = null
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