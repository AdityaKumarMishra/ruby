var ready;
ready = function() {
    upTime(new Date());
}
$(document).ready(ready);
$(document).on('page:load', ready);

function upTime(countTo) {
    now = new Date();
    countTo = new Date(countTo);
    difference = (now-countTo);

    hours=Math.floor((difference%(60*60*1000*24))/(60*60*1000)*1);
    mins=Math.floor(((difference%(60*60*1000*24))%(60*60*1000))/(60*1000)*1);
    secs=Math.floor((((difference%(60*60*1000*24))%(60*60*1000))%(60*1000))/1000*1);

    $('#time').val(hours+":"+mins+":"+secs);

    clearTimeout(upTime.to);
    upTime.to=setTimeout(function(){ upTime(countTo); },1000);
}
