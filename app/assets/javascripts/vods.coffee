# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
change = ->
  for player in document.getElementsByClassName 'video-js'
    video = videojs('#video-js',{controls: true, autoplay:true,plugins:{resolutionSelector : {}}})
    $('video-js').bind 'contextmenu', ->
    false
vjs.PlaybackRateMenuButton::onClick = ->
  currentRate = @player().playbackRate()
  @player().playbackRate currentRate
  return

$(document).on('ready', change)
