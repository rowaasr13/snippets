// https://steamcommunity.com/id/<>/badges/

document.querySelectorAll(".badge_row .progress_info_bold").forEach(el => {
    if (el.innerText.match(/no card drops remaining/i)) {
        let row = el.closest(".badge_row")
        row.remove()
    }
})