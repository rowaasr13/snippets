// download image once and duplicate it in memory with blob

var xhr = new XMLHttpRequest()
xhr.open("GET", "https://i.imgur.com/CZVM2je.jpeg")
xhr.responseType = "blob"
xhr.onload = response
xhr.send()

function response(e) {
   var imageUrl = URL.createObjectURL(this.response)

   var el1 = document.createElement('img')
   el1.src = imageUrl
   document.body.appendChild(el1)

   var el2 = document.createElement('img')
   el2.src = imageUrl
   document.body.appendChild(el2)
}