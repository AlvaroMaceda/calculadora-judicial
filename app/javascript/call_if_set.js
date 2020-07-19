function callIfSet(func, ...args) {
  return ( func && func(...args) ) || undefined
}

export default callIfSet;