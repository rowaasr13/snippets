// nyaa proxy

document.querySelectorAll('a[href*="mylink.cx"]').forEach((a) => {
    let url = new URL(a.href)
    if (url.hostname == 'mylink.cx') {
        a.href = url.searchParams.get('url')
    }
})