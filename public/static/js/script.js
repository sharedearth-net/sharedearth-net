$(document).ready(function(){ // This sets the opacity of the thumbs to fade down to 60% when the page loads
$("h1 a").fadeTo("slow", 1);

$("h1 a").hover(function(){
$("h1 a").fadeTo("slow", 0.5); // This sets the opacity to 100% on hover
},function(){
$("h1 a").fadeTo("slow", 1); // This sets the opacity back to 60% on mouseout
});
});


$(document).ready(function(){ // This sets the opacity of the thumbs to fade down to 60% when the page loads
$(".button-holder-host a").fadeTo("slow", 0.7);

$(".button-holder-host a").hover(function(){
$(".button-holder-host a").fadeTo("slow", 1); // This sets the opacity to 100% on hover
},function(){
$(".button-holder-host a").fadeTo("slow", 0.7); // This sets the opacity back to 60% on mouseout
});
});


