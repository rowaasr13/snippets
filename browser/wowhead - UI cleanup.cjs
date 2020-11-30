;(function() {
    // Almost like .closest, but checks that each parent element on the way
    // have only one child, so there's no porentially useful content
    // in branch about to be deleted
    function find_and_climb_to_parent(find, parent) {
        let element = document.querySelector(find)
        if (!element) {
            console.log(find, "not found")
            return
        }

        while (element = element.parentElement) {
            if (element.childElementCount > 1) {
                console.log(find, "more than 1 child at", element)
                return
            }

            if (element.parentElement && (element.parentElement.querySelector(parent) === element)) {
                console.log(find, "parent", parent, "found")
                element.remove()
                return
            }
        }
    }

    let target = document.querySelector("#sidebar-zamaf-bt-ph")
    target && target.remove()

    target = document.querySelector("#video-pos-static")
    target && target.remove()

    find_and_climb_to_parent('#ad-horizontal', '.blocks')
    find_and_climb_to_parent('#ad-vertical', '.sidebar-wrapper')

    target = document.querySelector("#page-content")
    if (target) { target.style.paddingRight = 'unset' }
})();
