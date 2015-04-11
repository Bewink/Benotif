package views;

import js.html.InputElement;
import js.Browser;
import js.html.LIElement;
import utils.Listener;
import js.html.SpanElement;
import js.Cookie;
import js.html.Event;

@view('views/Option.html')
class Option extends View {
    public function new(parent) {
        super(parent);
        this.parseHTML();
    }

    private function parseHTML() {
        var checkbox:InputElement = cast this.content.getElementsByTagName('input')[0];
        var link:SpanElement = cast this.content.getElementsByTagName('span')[0];

        addCSS(checkbox, link);

        parent.innerHTML = this.getHTML() + parent.innerHTML;

        var firstLi:LIElement = cast parent.getElementsByTagName('li')[0];

        addJS(cast firstLi.getElementsByTagName('input')[0], cast firstLi.getElementsByTagName('span')[0]);
    }

    private function addCSS(checkbox:InputElement, link:SpanElement) {
        checkbox.style.verticalAlign = "middle";
        link.style.cursor = "pointer";
    }

    public function addJS(checkbox:InputElement, link:SpanElement) {
        checkbox.checked = Cookie.get('benotif-enabled') == '1';

        Listener.add(link, 'mouseover', function() {
            untyped __js__('this').style.color = 'white';
        });
        Listener.add(link, 'mouseout', function() {
            untyped __js__('this').style.color = 'inherit';
        });
        Listener.add(link, 'click', function() {
            Browser.window.dispatchEvent(new Event('settingsrequested'));
        });
        Listener.add(checkbox, 'change', checkboxChangeHandler);
    }

    public function checkboxChangeHandler(e:Event) {
        var checkbox:InputElement = cast e.target;
        Cookie.set('benotif-enabled', (checkbox.checked ? '1' : '0'));
    }
}
