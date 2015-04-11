package ;

import utils.Notification;
import js.html.Node;
import js.html.SourceElement;
import js.html.AudioElement;
import js.html.TitleElement;
import js.html.Element;
import js.html.Document;
import utils.Logger;
import js.html.IFrameElement;
import views.Option;
import js.Browser;
import utils.Listener;
import utils.Lightbox;
import views.Settings;
import js.Cookie;

@:expose class Benotif {
    private static var instance(get, null):Benotif;
    private var options:Array<Array<String>>;
    private var title:TitleElement;
    private var iframe:IFrameElement;
    private var chatboxDocument:Document;
    private var chatbox:Element;
    private var timer:Int;
    private var messageCount:Int;

    public function new() {
        options = [
            ['enabled', '0'],
            ['light', '1'],
            ['sound', '1'],
            ['desktop', '0']
        ];

        title = cast Browser.document.getElementsByTagName('title')[0];
        iframe = cast Browser.document.getElementById('frame_chatbox');

        initCookies();
        initListeners();
    }

    public static function main() {
        Listener.add(Browser.document, 'DOMContentLoaded', function() {
            instance = new Benotif();
        });
    }

    private function initTimer() {
        timer = Browser.window.setInterval(checkNewMessages, 200);
    }

    private function checkNewMessages() {
        var activated = isOn('enabled');
        var newMessage = chatbox.getElementsByTagName('p').length != messageCount;
        var focus = Browser.document.hasFocus();
        var connected = chatboxDocument.getElementById('chatbox_option_co').style.display == "none";

        if(newMessage && !focus && activated && connected) {
            if(isOn('light')) {
                triggerLightNotification();
            }
            if(isOn('sound')) {
                triggerSoundNotification();
            }
            if(isOn('desktop')) {
                triggerDesktopNotification();
            }
        }

        messageCount = chatbox.getElementsByTagName('p').length;
    }

    private function triggerLightNotification() {
        title.innerHTML = title.innerHTML + ' | Nouveau message !';
        Browser.window.setTimeout(function() {
            title.innerHTML = title.innerHTML.substring(0, ((title.innerHTML.toString().length)-20));
        }, 5000);
    }

    private function triggerSoundNotification() {
        var audio:AudioElement = cast Browser.document.createElement('audio');
        var source1:SourceElement = cast Browser.document.createElement('source');
        var source2:SourceElement = cast Browser.document.createElement('source');

        audio.setAttribute('autoplay', 'autoplay');
        Listener.add(audio, 'ended', function() {
            var that:Node = cast audio;
            that.parentNode.removeChild(that);
        });

        source1.setAttribute('src', 'http://bew.ink/public/sound/lycampire/clic.ogg');
        source1.setAttribute('type', 'audio/ogg');

        source2.setAttribute('src', 'http://bew.ink/public/sound/lycampire/clic.mp3');
        source2.setAttribute('type', 'audio/mpeg');

        var audioNode:Node = cast audio;
        audioNode.appendChild(source1);
        audioNode.appendChild(source2);

        var bodyNode:Node = cast Browser.document.body;
        bodyNode.appendChild(audio);
    }

    private function triggerDesktopNotification() {
        var pList:Array<Element> = cast chatbox.getElementsByTagName('p');
        var lastP:Element = cast pList[pList.length - 1];

        if(lastP.getElementsByClassName('user-msg').length > 0) {
            var user = null;
            var messageElement:Element = cast lastP.getElementsByClassName('user-msg')[0];
            var userElement:Element;
            var message:String;

            messageElement = cast messageElement.getElementsByClassName('msg')[0];
            messageElement = cast messageElement.getElementsByTagName('span')[0];
            message = ~/<[^>]+>/g.replace(messageElement.innerHTML, '');

            userElement = cast lastP.getElementsByClassName('user-msg')[0];

            if(userElement.getElementsByClassName('user').length > 0) {
                userElement = cast userElement.getElementsByClassName('user')[0];
                userElement = cast userElement.getElementsByTagName('strong')[0];
                userElement = cast userElement.getElementsByTagName('span')[0];

                user = userElement.innerHTML;
            }

            Notification.add('Lycampire : Nouveau message', user + ' : ' + message);
        } else if(lastP.getElementsByClassName('msg').length > 0) {
            var messageElement:Element = cast lastP.getElementsByClassName('msg')[0];
            var message:String;

            messageElement = cast messageElement.getElementsByTagName('span')[0];
            messageElement = cast messageElement.getElementsByTagName('strong')[0];
            message = ~/<[^>]+>/g.replace(messageElement.innerHTML, '');

            Notification.add('Lycampire : Nouveau message', message);
        }
    }

    private function isOn(kind:String):Bool {
        return Cookie.get('benotif-' + kind) == '1';
    }

    private function initListeners() {
        Listener.add(Browser.window, 'settingsrequested', function() {
            var settings = new Settings();
            Lightbox.display(settings.getHTML(), function() {
                settings.addJS(cast Lightbox.get_container().getElementsByTagName('input'));
            });
        });

        Listener.add(Browser.window, 'settingssaved', function() {
            Lightbox.close();
        });

        Listener.add(this.iframe, 'load', function() {
            var option = new Option(this.iframe.contentDocument.getElementById('chatbox_main_options'));
            chatboxDocument = iframe.contentDocument;
            chatbox = chatboxDocument.getElementById('chatbox');
            initTimer();
        });
    }

    private function initCookies() {
        for (i in 0...options.length) {
            var kind = options[i][0];
            var value = options[i][1];
            if(!Cookie.exists('benotif-' + kind)) {
                Cookie.set('benotif-' + kind, value, 365);
            } else if(Cookie.exists('benotif-' + kind) && (Cookie.get('benotif-' + kind) == '0' || Cookie.get('benotif-' + kind) == '1')) {
                options[i][1] = Cookie.get('benotif-' + kind);
            }
        }
    }

    public static function get_instance():Benotif {
        return instance;
    }
}