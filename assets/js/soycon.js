/**
 * soycon - Source code to soycon.es.
 * @version v1.0.0
 * @link    http://soycon.es
 * @author  Abel Nieva <biz@abelnieva.com>
 * @license ISC
 */
(function(){var soycon;window.soycon=soycon={version:"1.0.0"},$(function(){return soycon.dom={document:$(document),width:window.innerWidth||document.documentElement.offsetWidth,height:window.innerHeight||document.documentElement.offsetHeight,nav:$("nav"),intro:$("#intro"),email:$(".js-email")},$(document).on("scroll",function(event){var percent,px;return px=soycon.dom.document.scrollTop(),percent=100*px/soycon.dom.intro.height(),percent>80?soycon.dom.nav.addClass("site-nav--filled"):soycon.dom.nav.removeClass("site-nav--filled")}),$(document).on("ready",function(event){var email;return email=soycon.dom.email.attr("data-email"),email=email.replace(RegExp(" dot ","gi"),"."),email=email.replace(RegExp(" at ","gi"),"@"),soycon.dom.email.attr("href","mailto:"+email),soycon.dom.email.html(email)})})}).call(this);