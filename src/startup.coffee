CustomEvents = require('customevents')
LiveReload = window.LiveReload = new (require('livereload').LiveReload)(window)

for k of window when k.match(/^LiveReloadPlugin/)
  LiveReload.addPlugin window[k]

LiveReload.addPlugin require('less')

LiveReload.on 'shutdown', -> delete window.LiveReload
LiveReload.on 'connect', ->
  CustomEvents.fire document, 'LiveReloadConnect'

  # Styles for reload animations
  head = document.getElementsByTagName('head')[0]
  style = document.createElement 'style'
  declaration = 'transition: all 280ms ease-out;'
  declarations = ((prefix + declaration) for prefix in ['-webkit-', '-moz-', '-ms-', '-o-']).join(' ')
  css = ".livereload-loading * { " + declarations +  "}"
  if style.styleSheet
    style.styleSheet.cssText = css
  else
    style.appendChild(document.createTextNode(css))

  head.appendChild(style)

LiveReload.on 'disconnect', ->
  CustomEvents.fire document, 'LiveReloadDisconnect'

LiveReload.on 'reload', ->
  html = document.body.parentNode
  loadingClass = ' livereload-loading'
  currentHtmlClass = html.getAttribute('class') ? ''

  html.setAttribute('class', currentHtmlClass.replace(loadingClass, '') + "#{loadingClass}")

  setTimeout (-> html.setAttribute('class', currentHtmlClass.replace(loadingClass, ''))), 2000

CustomEvents.bind document, 'LiveReloadShutDown', -> LiveReload.shutDown()
