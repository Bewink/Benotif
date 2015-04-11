package utils;

class Logger {
    public static function log(message:Dynamic) {
        untyped __js__('console.log(message)');
    }

    public static function info(message:Dynamic) {
        untyped __js__('console.info(message)');
    }

    public static function error(message:Dynamic) {
        untyped __js__('console.error(message)');
    }

    public static function warn(message:Dynamic) {
        untyped __js__('console.warn(message)');
    }
}
