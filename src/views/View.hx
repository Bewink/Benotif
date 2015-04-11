package views;

import js.html.Element;
import js.html.DivElement;

@:autoBuild(macros.ViewFactory.build())
class View {
    private var content:DivElement;
    private var parent:Element;

    public function new(?parent) {
        this.content = this.getContent();
        this.parent = parent;
    }

    public function getHTML():String {
        return this.content.innerHTML;
    }

    private function getContent():DivElement {
        var html:String =  untyped this.view;
        var container:DivElement = js.Browser.document.createDivElement();

        container.innerHTML = html;

        return container;
    }
}
