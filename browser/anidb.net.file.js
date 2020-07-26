// https://anidb.net/file/(?:\d+)

(() => {

const selectors = {
    size     : "tr.size>td.value",
    ed2k     : "tr.ed2k>td.value",
    extension: "tr.type>td.value",
    anime    : "tr.relation>td.value>a[href*='/anime/'",
    episode  : "tr.relation>td.value>a[href*='/episode/'",
    group    : "tr.group>td.value>a[href*='/group/'",
    quality  : "tr.quality>td.value",
}

let val = {}
Object.keys(selectors).forEach((key) => {
    let found = document.querySelector(selectors[key])
    if (!found) { throw `Not found ${key} with selector ${selectors[key]}` }
    val[key] = found.textContent
})

let size = val.size.match(/^([\d.]+)/)
val.size = parseInt(size[1].replace(/\D/g, ''), 10)

let extension = val.extension.match(/^video file, (.+)$/)
if (!extension) { throw "Can't get extension from type in data table" }
val.extension = extension[1]

val.quality = val.quality.replace(/ \/[^\/]*\/ Version /, ' v')

let filename = encodeURIComponent(`${val.anime} - ${val.episode} [${val.group}](${val.quality}).${val.extension}`)
return `ed2k://|file|${filename}|${val.size}|${val.ed2k}|/`

})()