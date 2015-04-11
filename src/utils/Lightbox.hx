package utils;

import js.html.Node;
import js.html.DivElement;
import js.Browser;

class Lightbox {
    private static var shadow:DivElement;
    private static var container(get, null):DivElement;
    private static var isOpenned:Bool;

    public static function display(content:String, callback:Dynamic) {
        if(isOpenned) {
            close();
        }

        init(content);
        callback();
    }

    private static function init(content:String) {
        isOpenned = true;

        shadow = Browser.document.createDivElement();
        container = Browser.document.createDivElement();

        var body:Node = cast Browser.document.body;
        var shad:Node = cast shadow;

        body.appendChild(shadow);
        shad.appendChild(container);

        container.innerHTML = content;

        setShadowStyle();
        setContainerStyle();
    }

    private static function setShadowStyle() {
        var s = shadow.style;

        s.position = 'fixed';
        s.zIndex = '9999';
        s.width = s.height = '100%';
        s.top = s.left = s.padding = s.margin = '0';
        s.background = 'rgba(0, 0, 0, 0.7)';
    }

    private static function setContainerStyle() {
        var s = container.style,
            padding = 10;

        s.display = 'inline-block';
        s.background = 'white';
        s.position = 'absolute';
        s.top = s.left = '50%';
        s.padding = padding + 'px';
        s.borderRadius = '3px';
        s.border = '1px solid #505050';
        s.marginTop = (-(container.offsetHeight / 2)) + 'px';
        s.marginLeft = (-(container.offsetWidth / 2)) + 'px';
    }

    public static function get_container():DivElement {
        return container;
    }

    public static function close() {
        if(container != null) {
            container.remove();
        }
        if(shadow != null) {
            shadow.remove();
        }

        shadow = container = null;
        isOpenned = false;
    }
}
