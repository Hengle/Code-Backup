﻿window["oncontextmenu"]= function(){return false};jQuery(document)["ready"](function($){$(".checkbox")["on"]("click",function(){$(this)["toggleClass"]("active")})});var gradient_slide_max=500;jQuery(document)["ready"](function($){$(".navigation .js-help")["on"]("click",function(){$(".modal-help")["modal"]({fadeDuration:250,showClose:false})});$(".switch-textures")["on"]("click",function(){var id=$(this)["attr"]("data-id");$(".textures-wrap, .switch-textures")["removeClass"]("active");$(".textures-wrap[data-id=\""+ id+ "\"]")["addClass"]("active");$(this)["addClass"]("active")});$(".js-slider")["each"](function(){var value_element=$(this)["siblings"](".js-slider-value");var slide_min=parseInt($(this)["attr"]("data-min"));var slide_max=parseInt($(this)["attr"]("data-max"));var slide_step=parseInt($(this)["attr"]("data-step"));var slide_value=parseInt($(this)["attr"]("data-value"));var empty=[];var suffix="";if($("body")["hasClass"]("icons")){suffix= " %"};if($(this)["hasClass"]("slider-contours")){var slider=$(this)["slider"]({min:10,max:50,value:10,step:1,create:function(event,ui){},slide:function(event,ui){},change:function(event,ui){}})["slider"]("float")}else {if($(this)["hasClass"]("gradient")){$(this)["slider"]({min:slide_min,max:slide_max,step:slide_step,value:slide_value,stop:function(event,ui){var cur_value=parseInt($(".js-slider.gradient .ui-slider-tip")["text"]());var max_value=parseInt($(".js-slider-input")["val"]());var result=Math["round"](255/ (max_value/ cur_value));go_gradient(result)}})["slider"]("float")}else {if($(this)["hasClass"]("slider-rips")){$(this)["slider"]({min:slide_min,max:slide_max,step:slide_step,value:slide_value,create:function(event,ui){setTimeout(function(){$(".slider-rips")["append"]("<div class=\"slider-rips-overlay\"></div>")},100)}})["slider"]("pips",{rest:"label",labels:empty})["slider"]("float")}else {$(this)["slider"]({min:slide_min- 1,max:slide_max+ 1,step:slide_step,value:slide_value,slide:function(event,ui){if(ui["value"]< slide_min){$(this)["slider"]("option","value",slide_min);$(this)["find"](".ui-slider-tip")["text"](slide_min+ suffix);return false}else {if(ui["value"]> slide_max){$(this)["slider"]("option","value",slide_max);$(this)["find"](".ui-slider-tip")["text"](slide_max+ suffix);return false}}}})["slider"]("float",{suffix:suffix})}}}});$(".modal-map .map-list li")["on"]("click",function(){$(this)["addClass"]("active")["siblings"]("li")["removeClass"]("active")});$(".js-slider-input")["on"]("keypress blur",function(e){if(e["which"]== 13|| e["type"]== "blur"){updateGradientSlider()}});$(".hover img")["each"](function(){var src=$(this)["attr"]("src");$(this)["attr"]("data-src",src)});$("li")["on"]("click",function(){var trigger=$(this)["attr"]("data-trigger");switch(trigger){case "help":$(".modal-help")["modal"]({fadeDuration:250,showClose:false});break;case "examples":$(".modal-examples")["modal"]({fadeDuration:250,showClose:false});break}});$(".hover")["on"]("mouseenter",function(){showHoverImage($(this)["find"]("img"))})["on"]("mouseleave",function(){hideHoverImage($(this)["find"]("img"))});function showHoverImage(element){var hover=element["attr"]("src")["split"](".");hover= hover[0]+ "_hover."+ hover[1];element["attr"]("src",hover)}function hideHoverImage(element){var src=element["attr"]("data-src");element["attr"]("src",src)}});function updateGradientSlider(){var cur_value=jQuery(".js-slider.gradient")["slider"]("value");var factor=gradient_slide_max/ cur_value;var new_max=parseInt(jQuery(".js-slider-input")["val"]());gradient_slide_max= new_max;jQuery(".js-slider.gradient")["slider"]("option","value",Math["round"](new_max/ factor));jQuery(".js-slider.gradient")["slider"]("option","max",new_max)}function OpenModal(modal){jQuery(".modal-"+ modal)["modal"]({fadeDuration:250,showClose:false})}function showLoading(){jQuery(".modal-loading")["modal"]({fadeDuration:250,showClose:false,escapeClose:false})}function hideLoading(){jQuery["modal"]["close"]()}function hideLoading2(){jQuery["modal"]["close"]();OpenModal("textures")}function findNearest(includeLeft,includeRight,value,values){var nearest=null;var diff=null;for(var i=0;i< values["length"];i++){if((includeLeft&& values[i]<= value)|| (includeRight&& values[i]>= value)){var newDiff=Math["abs"](value- values[i]);if(diff== null|| newDiff< diff){nearest= values[i];diff= newDiff}}};return nearest}function getSliderValue(slider_id){var value=jQuery("#"+ slider_id+ " .js-slider")["slider"]("value");if(slider_id== "slider_contour"){value= parseInt(jQuery("#"+ slider_id+ " .ui-slider-tip")["text"]())};return value}function maxLengthCheck(object){if(object["value"]["length"]> object["maxLength"]){object["value"]= object["value"]["slice"](0,object["maxLength"])}}function isNumeric(evt){var theEvent=evt|| window["event"];var key=theEvent["keyCode"]|| theEvent["which"];var special=[8,37,38,39,40,46];if(!inArray(key,special)){key= String["fromCharCode"](key);var regex=/[0-9]|\./;if(!regex["test"](key)){theEvent["returnValue"]= false;if(theEvent["preventDefault"]){theEvent["preventDefault"]()}}}}