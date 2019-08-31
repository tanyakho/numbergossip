// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var JRPEffect = {
    toggle_blind: function() {
        for (var i = 0; i < arguments.length; i++) {
            var element = $(arguments[i]);
            if(Element.visible(element)) {
                Effect.BlindUp(element, {duration: 0.2 });
            } else {
                Effect.BlindDown(element, {duration: 0.2});
            }
        }
    },

    toggle_slide: function() {
        for (var i = 0; i < arguments.length; i++) {
            var element = $(arguments[i]);
            if(Element.visible(element)) {
                Effect.SlideUp(element, {duration: 0.2 });
            } else {
                Effect.SlideDown(element, {duration: 0.2});
            }
        }
    }
}
