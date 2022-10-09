;(() => {
  // 1138 640
  let height = 916
  let width = Math.floor(height * 1.778125)
  console.log("Width:", width)

  let main = document.querySelector('#magicami-main')

  let canvas = document.querySelector('#unityCanvs')

  if (canvas) {
    console.log("Looks like 'Main' frame")

    let game_container_style = document.querySelector('#gameContainer').style
    game_container_style.top = 'initial'
    game_container_style.transform = 'translateX(-50%)'

    game_container_style.width  = width  + 'px'
    game_container_style.height = height + 'px'

    canvas.setAttribute('width' , width )
    canvas.setAttribute('height', height)
    canvas.style.width  = width  + 'px'
    canvas.style.height = height + 'px'
  } else if(main) {
    console.log("Looks like 'ifr' frame")

    document.querySelector('#magicami_contents_separator').style.display = 'none'
    main.style.height = height + 'px'
  } else {
    console.log("Unknown frame, probably top")
  }

})();
