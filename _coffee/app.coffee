window.soycon = soycon = version: "1.0.0"

$ ->
  soycon.dom =
    document    : $ document
    width       : window.innerWidth or document.documentElement.offsetWidth
    height      : window.innerHeight or document.documentElement.offsetHeight
    nav         : $ "nav"
    intro       : $ "#intro"
    email       : $ ".js-email"
    flexslider  : $ ".flexslider"

  $(document).on "scroll", (event) ->
    px = soycon.dom.document.scrollTop()
    percent = (px * 100) / soycon.dom.intro.height()

    # -- nav
    if percent > 80
      soycon.dom.nav.addClass "site-nav--filled"
    else
      soycon.dom.nav.removeClass "site-nav--filled"

  $(document).on "ready", (event) ->
    email = soycon.dom.email.attr "data-email"
    email = email.replace(RegExp(" dot ", "gi"), ".")
    email = email.replace(RegExp(" at ", "gi"), "@")

    # -- email
    soycon.dom.email.attr "href", "mailto:" + email
    soycon.dom.email.html email

    # -- flexslider
    soycon.dom.flexslider.flexslider directionNav: false
