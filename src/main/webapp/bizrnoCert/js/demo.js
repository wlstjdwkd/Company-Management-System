/**
 * Created by jhkoo77 on 2015-09-03.
 */

function objectToTable(caption, data) {
    caption = caption || "";
    var table = '<table class="custom table table-striped"><captoin>'+caption+'</captoin><col width=30% ></col><col width=70%></col>';
    for(var prop in data) {
        table += '<tr><td>';
        table += prop;
        table += '</td><td>';
        if(typeof data[prop] == "object") {
            table += objectToTable("",data[prop]);
        }
        else {
            table += data[prop];
        }
        table += '</td></tr>';

    }
    table += '</table>';
    return table;
}

function add0(num) {
    var ret = "0";
    if(num >= 10)
        return num;
    return ret + num;
}
function getDateString(date) {
    var ret = "";
    ret += date.getFullYear();
    ret += "-";
    ret += add0(date.getMonth());
    ret += "-";
    ret += add0(date.getDay());
    ret += " ";
    ret += add0(date.getHours());
    ret += ":";
    ret += add0(date.getMinutes());
    ret += ":";
    ret += add0(date.getSeconds());
    return ret;

}

//session cookie
var wiz = {};
wiz.util = {};

wiz.util.cookie = wiz.util.cookie || (function($){
        var _cookie = {};

        _cookie.get = function(name) {
            try {
                var nameOfCookie = name + "=";
                var x = 0;
                while ( x <= document.cookie.length ) {
                    var y = (x+nameOfCookie.length);
                    if ( document.cookie.substring( x, y ) == nameOfCookie ) {
                        if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
                            endOfCookie = document.cookie.length;
                        return decodeURI( document.cookie.substring( y, endOfCookie ) );
                    }
                    x = document.cookie.indexOf( " ", x ) + 1;
                    if ( x == 0 ) break;
                }
            }
            catch(err) {
            }
            return "";
        };
        _cookie.set = function(name,val) {
            document.cookie = name+"="+encodeURI(val)+"; path=/;";
        };
        return _cookie;

    })(jQuery);

function saveCookie(key,val) {
    wiz.util.cookie.set(key,val);
}
$(document).ready(function(){
    $("button").each(function(){
        $(this).addClass("btn btn-default");
    });

    $("#ssn").each(function(){
        var ssn = wiz.util.cookie.get("ssn");
        $(this).val(ssn);
    });
});