package utils;

import js.html.XMLHttpRequest;

class Ajax {
    public static var xhr:XMLHttpRequest;

    public static function init() {
        if (untyped __js__("typeof XMLHttpRequest") != "undefined" || untyped __js__("typeof ActiveXObject") != "undefined") {
            if (untyped __js__("typeof ActiveXObject") != "undefined") {
                try {
                    xhr = untyped __js__('new ActiveXObject("Msxml2.XMLHTTP")');
                } catch(e:Dynamic) {
                    xhr = untyped __js__('new ActiveXObject("Microsoft.XMLHTTP")');
                }
            } else {
                xhr = new XMLHttpRequest();
            }
        } else {
            Logger.error("Object XMLHTTPRequest not supported");
        }
    }

    public static function prepare(callback:Dynamic):Void {
        if(xhr == null) {
            init();
        }

        Listener.add(xhr, 'readystatechange', function() {
            if (xhr.readyState == 4 && (xhr.status == 200 || xhr.status == 0)) {
                callback(xhr.response);
            }
        });
    }

    public static function get(url:String, parameters:String, callback:Dynamic, ?asynchronous = true):Void {
        prepare(callback);

        xhr.open('GET', url, asynchronous);
        xhr.send(parameters);
    }

    public static function post(url:String, parameters:String, callback:Dynamic, ?asynchronous = true):Void {
        prepare(callback);

        xhr.open('POST', url, asynchronous);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send(parameters);
    }
}