(() => {
  let frame = document.querySelector('#game_frame')
  if (!frame) { console.log("no #game_frame found"); return }
  let st = new URLSearchParams(new URL(frame.src).search).get('st')

  let tw_params = new URLSearchParams(
    'synd=johren&container=johren&owner=jrn-1081304&viewer=jrn-1081304&aid=jrn-16375&mid=1&country=US&lang=en&view=canvas'
    + '&parent=https%3A%2F%2Fwww.johren.net&url=https%3A%2F%2Ftw-api.magicami.johren.games%2Fgadget%2Fgadget_tw.xml&noinfo=0&nocache=0&debug=1&view-params='
  )
  tw_params.set('st', st)
  let tw_link = 'https://osapi.johren.net/gadgets/ifr?' + tw_params.toString()
  console.log(tw_link)
})()
