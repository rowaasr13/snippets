// not a module format, so you can run it in online compilers
"use strict";

const url_reddit_search_loot = 'https://www.reddit.com/r/idlechampions/search.json?q=flair_name%3A%22loot%22&restrict_sr=1&sort=new'
const code_one_letter_range = '0-9A-Za-z*&^%$#@!'

const https = require('https')

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
    patterns.forEach((val, idx, array) => {
        array[idx] =
            '(?:^|(?<!' + code_one_letter_rx  + '))' + // boundary or start of line lookbehind
            '(' + val + ')' +                          // pattern
            '(?:$|(?!' + code_one_letter_rx + '))'     // boundary or end of line lookahead
    })
    const all_patterns = RegExp(patterns.join('|'))

    return all_patterns
}

function https_request_add_promise(url, options, resolve, reject) {
    let request = https.get(url, options, (res) => {
        let data = '';

        res.on('data', (chunk) => data += chunk)

        res.on('end', () => {
            res.data = data
            resolve(res)
        })
    }).on('error', (err) => reject(err))

    return request
}

async function get_reddit_posts() {
    const request = new Promise((resolve, reject) => https_request_add_promise(
        url_reddit_search_loot,
        {},
        resolve, reject
    ))
    const res = request.then(res => {
        const obj = JSON.parse(res.data)
        return obj
    })
    return res
}

function push_code(array, code, data) {
    const normalized = code.replace(/\-/g, '').toLowerCase()
    const exists = array.uniq[normalized]

    if (exists) { return }

    array.push(code)
}

function push_error(array, data) {
    array.push(data)
}

async function main() {
    const all_patterns = get_code_patterns()

    let reddit_obj, discord_obj

    await Promise.all(
        [ get_reddit_posts() ]
    ).then(res => {
        [ reddit_obj ] = res
    })

    // console.log(reddit_obj)
    // console.log(reddit_obj.data.children)

    const codes = []
    codes.uniq = {}
    const errors = []

    reddit_obj.data.children.forEach((post, idx) => {
        // console.log(post.data.selftext)

        // mycompiler.io's nodejs doesn't have .replaceAll
        const match = post.data.selftext.replace(/&amp;/g, "&").match(all_patterns)
        if (!match) {
            push_error(errors, { text: post.data.selftext, source_type: 'reddit', source: post })
        } else {
            push_code(codes, match[0], { source_type: 'reddit', source: post })
        }
    })

    if (codes.length > 0) {
        for (const code of codes) {
            console.log(code)
        }
    }

    if (errors.length > 0) {
        console.log("\n\n\n=== Errors ===")
        for (const error of errors) {
            console.log('=== Reddit parse error ===')
            console.log(error.text)

        }
    }
}

main()
