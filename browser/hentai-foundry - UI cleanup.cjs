;(function() {

    function redirect_to_canonical_https() {
        let new_url = new URL(location)
        let new_url_replace
        let hf_pattern = /hentai-foundry.com$/i;

        if (!new_url.host.match(hf_pattern)) {
            let params = new URLSearchParams(new_url.search)
            let url_from_params = params.get('url')
            if (url_from_params) {
                if (!url_from_params.match("https?://")) {
                    url_from_params = "https://" + url_from_params
                }
                new_url = new URL(url_from_params)
                new_url_replace = true
            }
        }

        if (new_url.host.match(hf_pattern) && new_url.protocol == 'http:') {
            new_url.protocol = "https:"
            new_url_replace = true
        }

        if (new_url_replace) {
            location.replace(new_url)
        }

        return new_url_replace
    }

    let main = function() {
        if (redirect_to_canonical_https()) { return }

        let target = document.getElementById("frontPage_link")
        // TODO: see about extending re-entry period; probably just a cookie
        if (target) { return target.click() }

        if (!(location && location.pathname.match(/^\/search\//))) {
            let changed_form
            document.querySelectorAll('input.ratingCheckbox').forEach(input => {
                let desired_state = input.id.match(/scat|yaoi/) ? false : true
                if ((!!input.checked) != desired_state) {
                    changed_form = input.form; console.log("changed", input.id)
                    input.click()
                }
            })
            if (changed_form) {
                let submit = changed_form.querySelectorAll("input[type='submit']")
                if (submit.length === 1) {
                    submit[0].click()
                } else {
                    console.log("more than one submit in filter", changed_form)
                }
            }
        }

        target = document.getElementById("logo")
        if (target) { target.parentElement.remove() }

        target = document.getElementById("searchBox")
        if (target) { target.style.position = "unset"; target.style.float = "left" }

        target = document.getElementById("headerLogin")
        if (target) { target.style.position = "unset" }

        target = document.getElementById("page")
        if (target) { target.style.margin = "unset"; target.style.padding = "unset" }

        target = document.getElementById("footer")
        if (target) { target.remove() }

        target = document.getElementById("resize_message")
        if (target) { target.style.margin = "0px" }

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
            let boxbody = target.parentElement
            let src = target.src

            boxbody.style.padding = "unset"

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
            boxbody.appendChild(link)
            link.appendChild(target)
        }
    }

    if (document && (document.readyState === 'interactive' || document.readyState === 'complete')) {
        return main()
    } else {
        window.addEventListener("DOMContentLoaded", main)
    }

})();
