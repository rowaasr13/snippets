;(function() {
    let main = function() {
        let target = document.getElementById("logo")
        if (target) { target.parentElement.remove() }

        target = document.getElementById("searchBox")
        if (target) { target.style.position = "unset"; target.style.float = "left" }

        target = document.getElementById("headerLogin")
        if (target) { target.style.position = "unset" }

        target = document.getElementById("page")
        if (target) { target.style.margin = "unset"; target.style.padding = "unset" }

        target = document.getElementById("footer")
        if (target) { target.remove() }

        target = document.body
        if (target) {
            let nodeIterator = document.createNodeIterator(document.body, NodeFilter.SHOW_COMMENT)
            while (nodeIterator.nextNode()) {
                let node = nodeIterator.referenceNode
                if (node.textContent.match(/^\s*Slot\s*number/i)) {
                    node.parentNode.remove()
                }
            }

            target.style.width = "99.9%"
            target.style.margin = "unset"
        }

        target = document.querySelector('.boxbody>img')
        if (target) {
            let src = target.src

            let onclick = target.getAttribute("onclick")
            let url_match
            if (onclick) {
                let url_match = onclick.match(/^this\.src='([^]+?)'/)
                if (url_match) {
                    target.removeAttribute("onclick")
                    src = url_match[1]
                }
            }

            let link = document.createElement('a')
            link.href = src
            target.parentElement.appendChild(link)
            link.appendChild(target)
        }
    }

    if (document && (document.readyState === 'interactive' || document.readyState === 'complete')) {
        return main()
    } else {
        window.addEventListener("DOMContentLoaded", main)
    }
})();
