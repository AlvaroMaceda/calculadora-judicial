function callIfSet(func, ...args) {
  console.log(args)
  return ( func && func(...args) ) || undefined
}

export default callIfSet;