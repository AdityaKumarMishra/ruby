//prevent printing func();
function preventPrinting(){
    var parentDoc = window.parent.document;
    var css = '* { display: none; }',
        head = parentDoc.head || parentDoc.getElementsByTagName('head')[0],
        style = parentDoc.createElement('style');

    style.type = 'text/css';
    style.media = "print";

    if (style.styleSheet){
        style.styleSheet.cssText = css;
    } else {
        style.appendChild(parentDoc.createTextNode(css));
    }

    head.appendChild(style);

    var css = '* { display: none; }',
        head = document.head || document.getElementsByTagName('head')[0],
        style = document.createElement('style');

    style.type = 'text/css';
    style.media = "print";
    if (style.styleSheet){
        style.styleSheet.cssText = css;
    } else {
        style.appendChild(document.createTextNode(css));
    }

    head.appendChild(style);
}

//prevent copying
//mouse
function disableSelect(el){
    if(el.addEventListener){
        el.addEventListener("mousedown",disabler,"false");
    } else {
        el.attachEvent("onselectstart",disabler);
    }
}

function disabler(e){
    if(e.preventDefault){ e.preventDefault(); }
    return false;
}

//keyboard
document.onkeydown = function (e) {
    e = e || window.event;
    if (e.ctrlKey) {
        var c = e.which || e.keyCode;
        switch (c) {
            case 65://Block Ctrl+A
                e.preventDefault();
                e.stopPropagation();
                break;
            case 67://Block Ctrl+C
                e.preventDefault();
                e.stopPropagation();
                break;
        }
    }
};

//preventPrinting();

var cont = document.getElementById('viewerContainer');
disableSelect(cont);