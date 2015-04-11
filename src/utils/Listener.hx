package utils;

class Listener {
    public static function add(obj:Dynamic, event:String, callback:Dynamic) {
        if(obj.addEventListener) {
            obj.addEventListener(event, callback, false);
        } else {
            obj.attachEvent("on" + event, callback);
        }
    }
}
