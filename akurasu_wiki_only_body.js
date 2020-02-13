(function() {
    const d = document
    function remove_element(el) {
        el.parentNode.removeChild(el)
    }

    remove_element(d.querySelector("#column-one"))
    remove_element(d.querySelector("#siteNotice"))
    remove_element(d.querySelector("#footer"))

    d.querySelector("#content").style.margin = 'initial'
})()