// Insert into "Custom JavaScript" (cjs) on site: moe.st
// Skip redirect/ads straight to hidden link

(function() {
    var d = document
    var real_href_prefix_plaintext = 'a.redirect").attr("href","'
    var real_href_rx = RegExp(real_href_prefix_plaintext.replace(/(\W)/g, '\\$1') + '([^"]+)', 'g')

    var scripts = d.evaluate("//script[contains(., '"+real_href_prefix_plaintext+"')]", d, null, XPathResult.ANY_TYPE, null)
    var script_text = scripts.iterateNext().textContent

    var matches
    while (matches = real_href_rx.exec(script_text)) {
        var href = matches[1]
        if (/^#/.test(href)) { continue }
        // console.log(href)
        location.replace(href)
    }
})()