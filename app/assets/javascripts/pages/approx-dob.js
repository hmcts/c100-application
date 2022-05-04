$(document).ready(function() {
  document.querySelectorAll(".dob input[type=text]").forEach(function(element){
    setInputFilter(element, function(value) {
      return /^\d*$/.test(value); // Allow digits only, using a RegExp
    }, "Only digits are allowed");
  })
})