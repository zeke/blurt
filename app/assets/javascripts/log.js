// log('hello world');
// log('myVar', myVar);
function log() {
  if (window.console) {
    for(var i in arguments) {
      console.log(arguments[i]);
    }
  }
}