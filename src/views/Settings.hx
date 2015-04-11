package views;

import js.html.LabelElement;
import js.Browser;
import js.html.Notification;
import js.html.InputElement;
import js.Cookie;
import js.html.Event;
import utils.Listener;
import js.html.Element;

@view('views/Settings.html')
class Settings extends View {

    public function new() {
        super();
        this.parseHTML();
    }

    private function parseHTML() {
        var title:Element = cast this.content.getElementsByClassName('benotif-title')[0];
        var block:Element = cast this.content.getElementsByClassName('benotif-block')[0];
        var inputs:Array<InputElement> = cast this.content.getElementsByTagName('input');
        var labels:Array<LabelElement> = cast this.content.getElementsByTagName('label');

        this.addCSS(title, block, inputs, labels);
    }

    private function addCSS(title:Element, block:Element, inputs:Array<InputElement>, labels:Array<LabelElement>) {
        title.style.width = "200px";
        title.style.marginTop = "0";
        title.style.color = "black";
        block.style.width = "200px";
        block.style.marginTop = "15px";
        block.style.marginBottom = "0";
        block.style.lineHeight = "20px";

        for(i in 0...inputs.length) {
            var input:Element = inputs[i];
            switch (input.getAttribute('type')) {
                case "checkbox":
                    input.style.verticalAlign = "middle";

                case "button":
                    input.style.display = "block";
                    input.style.margin = "10px auto 0 auto";
                    input.style.padding = "5px 10px";
                    input.style.borderRadius = "3px";
                    input.style.border = "1px solid black";
            }
        }

        for(i in 0...labels.length) {
            labels[i].style.color = "black";
        }
    }

    public function addJS(inputs:Array<InputElement>) {
        for(i in 0...inputs.length) {
            var input:InputElement = inputs[i];
            switch (input.getAttribute('type')) {
                case "checkbox":
                    var kind:String = input.getAttribute('id').substr(0, -12);
                    Listener.add(input, 'change', checkboxChangeHandler);
                    if(Cookie.exists('benotif-' + kind)) {
                        input.checked = Cookie.get('benotif-' + kind) == '1';
                    }

                case "button":
                    Listener.add(input, 'click', function() {
                        Browser.window.dispatchEvent(new Event('settingssaved'));
                    });
            }
        }
    }

    public function checkboxChangeHandler(e:Event) {
        var checkbox:InputElement = cast e.target;
        var kind:String = checkbox.getAttribute('id').substr(0, -12);

        Cookie.set('benotif-' + kind, (checkbox.checked ? '1' : '0'));

        if (Cookie.get('benotif-desktop') == '1' && untyped __js__('Notification.permission != "denied" && Notification.permission != "granted"')) {
            Notification.requestPermission(null);
        }
    }
}
