package utils;

import js.Browser;

class Notification {
    private static inline var NOTIFICATION_IMAGE_URL = 'http://bew.ink/public/images/lycampire/notification.png';

    private static var instance:js.html.Notification;
    private static var timeout:Int;

    public static function add(title:String, content:String):Void {
        if(instance != null) {
            instance.close();
            Browser.window.clearTimeout(timeout);
        }

        instance = new js.html.Notification(title, {
            body: content,
            icon: NOTIFICATION_IMAGE_URL
        });

        Listener.add(instance, 'click', function() {
            Browser.window.focus();
        });
        Listener.add(instance, 'mousemove', function() {
            Browser.window.clearTimeout(timeout);
        });
        Listener.add(instance, 'mouseout', setNotificationTimeout);

        setNotificationTimeout();
    }

    public static function setNotificationTimeout() {
        timeout = Browser.window.setTimeout(function() {
            instance.close();
        }, 5000);
    }
}
