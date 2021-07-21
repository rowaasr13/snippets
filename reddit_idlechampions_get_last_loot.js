// not a module format, so you can run it in online compilers
"use strict";

const code_one_letter_range = '0-9A-Za-z!*&^%#@'

function get_code_patterns() {
    const code_one_letter_rx = '[' + code_one_letter_range + ']'

    const patterns = [
        // 4 groups of XXXX (4 X) joined by '-': i.e. XXXX-XXXX-XXXX-XXXX
        Array(4).fill(code_one_letter_rx + '{4}').join("\\-"),
        // 3 groups of --""--
        Array(3).fill(code_one_letter_rx + '{4}').join("\\-"),
        // 16 X - i.e. just as first pattern, but without '-' delmiters
        code_one_letter_rx + '{16}',
        // 12 X
        code_one_letter_rx + '{12}',
    ]
    patterns.forEach((val, idx, array) => array[idx] = '\\b(' + val + ')\\b')
    const all_patterns = RegExp(patterns.join('|'))

    return all_patterns
}

async function main() {
    const https = require('https')

    const url_search_loot = 'https://www.reddit.com/r/idlechampions/search.json?q=flair_name%3A%22loot%22&restrict_sr=1&sort=new'

    const all_patterns = get_code_patterns()

    function https_get_promise(url, resolve, reject) {
        return https.get(url_search_loot, (res) => {
            let data = '';

            res.on('data', (chunk) => data += chunk)

            res.on('end', () => {
                res.data = data
                resolve(res)
            })

        }).on('error', (err) => reject(err))
    }


    let request = new Promise((resolve, reject) => https_get_promise(url_search_loot, resolve, reject))
    let res = await request
    let res_obj = JSON.parse(res.data)

    // console.log(res_obj.data.children)

    let errors = []
    res_obj.data.children.forEach((post, idx) => {
        // console.log(post.data.selftext)

        let match = post.data.selftext.match(all_patterns)
        if (!match) {
            errors.push(post)
        } else {
            console.log(match[0])
        }
    })

    if (errors.length > 0) {
        console.log("\n\n\n=== Errors ===")
        for (const post of errors) {
            console.log(post.data.selftext)
            console.log('======')
        }
    }
}

main()
