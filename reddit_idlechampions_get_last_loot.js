"use strict";

const url_reddit_search_loot = 'https://www.reddit.com/r/idlechampions/search.json?q=flair_name%3A%22loot%22&restrict_sr=1&sort=new'
const code_one_letter_range = '0-9A-Za-z*&^%$#@!'

let fetch = globalThis.fetch
if (!fetch) { fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args)) }

function get_code_patterns() {
    const code_one_letter_rx = '[' + code_one_letter_range + ']'

    const patterns = [
        // 4 groups of XXXX (4 X) joined by '-': i.e. XXXX-XXXX-XXXX-XXXX
        Array(4).fill(code_one_letter_rx + '{4}').join("[\\-_]"),
        // 3 groups of --""--
        Array(3).fill(code_one_letter_rx + '{4}').join("[\\-_]"),
        // 16 X with optional delimiters after each symbol
        Array(16).fill(code_one_letter_rx).join("\\-?"),
        // 12 X
        Array(12).fill(code_one_letter_rx).join("\\-?"),
    ]
    patterns.forEach((val, idx, array) => {
        array[idx] =
            '(?:^|(?<!' + code_one_letter_rx  + '))' + // boundary or start of line lookbehind
            '(' + val + ')' +                          // pattern
            '(?:$|(?!' + code_one_letter_rx + '))'     // boundary or end of line lookahead
    })
    const all_patterns = new RegExp(patterns.join('|'), 'g')

    return all_patterns
}

async function get_reddit_posts() {
    const request = fetch(url_reddit_search_loot)
    const res = request.then(res => res.json() )
    return res
}

function push_code(array, code, data) {
    const normalized = code.replace(/[\-_]/g, '').toLowerCase()
    const exists = array.uniq[normalized]

    if (exists) { return }
    array.uniq[normalized] = true

    array.push(code)
}

function push_error(array, data) {
    array.push(data)
}

function push_codes_from_text(args) {
    const env = this
    const patterns = env.patterns
    let text = args.text.replace(/&amp;/g, "&")
    let log_text = (args.log_text || args.text).replace(/&amp;/g, "&")

    // do not try to parse known channel names that just happen to match code format
    text = text.replace(/twitch\.tv\/(?:demiplanerpg|dungeonscrawlers)/ig, '')

    let match, had_match
    while ((match = patterns.exec(text)) !== null) {
        had_match = true
        push_code(env.codes, match[0], { source_id: args.source, raw: args.raw })
    }

    if (!had_match) {
        push_error(env.errors, { text: args.log_text, source_id: args.source, raw: args.raw })
    }
}

const document_body = (typeof document !== 'undefined') && document.body
const println = document_body ? function(...args) {
    const text = document.createTextNode([...args].join(' '))
    const wrapper = document.createElement('div')
    wrapper.appendChild(text)
    document_body.appendChild(wrapper)
} : function(...args) {
    console.log(...args)
}

async function main() {
    const all_patterns = get_code_patterns()

    let reddit_obj

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
    const env = {
        patterns: all_patterns,
        codes: codes,
        errors: errors,
        push_codes_from_text: push_codes_from_text
    }

    reddit_obj.data.children.forEach((post, idx) => {
        const html = post.data.selftext_html.replace(/&[a-z]{1,5};/g, function(entity) { return entity === '&amp;' ? '&' : ' ' })
        env.push_codes_from_text({ name: 'Reddit', text: html, log_text: post.data.selftext, raw: post })
    })

    if (codes.length > 0) {
        for (const code of codes) {
            println(code)
        }
    }

    if (errors.length > 0) {
        println("\n\n\n=== Errors ===")
        for (const error of errors) {
            println('=== Reddit parse error ===')
            println(error.text)

        }
    }
}

main()
