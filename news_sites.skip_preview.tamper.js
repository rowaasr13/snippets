// ==UserScript==
// @name           Various news sites: skip preview / remove trash
// @description    
// @author         rowaasr13@gmail.com
// @include        https://smi2.ru/*
// @include        *://ex.24smi.info/*
// @include        *://*.mirsegondya.com/*
// @include        https://press-profi.com/*
// @include        https://cliclo-info.ru/*
// @include        http://toprustory.ru/*
// @include        https://blamper.ru/*
// @include        https://politfox.ru/*
// @include        https://www.vesti.ru/*
// @include        https://www.lentainform.com/pnews/*
// @version        1.0
// ==/UserScript==

(function(_G) {
    /* %lib% */

    /* *************** main *************** */

    console_log("News site cleanup: starting up!")

    // https://smi2.ru/newdata/adpreview?ad=3301684&bl=77365&ct=adpreview&st=20&ab=b&utm_campaign=40392&utm_term=5a8927d7-5c8c-4c4c-974b-8f9e4b311ab8
    if (l[host] === 'smi2.ru') {
        var target_id = 'centralNewsHref'
        var el = d[querySelector]('a#'+target_id+' '+span+'.read-more')
        if (el) {
            while(el = el[parentNode]) {
                var prop_href
                if (el[id] === target_id && (prop_href = el[href])) {
                    // console_log(el)
                    l[replace](prop_href)
                }
            }
        }
    }

    // https://ex.24smi.info/top/in/1509145/2515/?subid=tgb_1v&subid1=preview_1509145&utm_campaign=9546114&utm_medium=banner&utm_content=29833720&utm_source=news.mail.ru
    if (l[host] === 'ex.24smi.info') {
        var el = d[querySelector]('a '+div+'.read-more')
        while (el = el[parentNode]) {
            if(el[tagName] === 'A') {
                var prop_href = el[href]
                if (prop_href) {
                    l[replace](prop_href)
                }
            }
        }
    }

    if (/mirsegondya\.com$/[test](l[host])) {
        var el = d[querySelector]('a.read-full')
        if (el) {
            l[replace](el[href])
        }
    }

    // https://press-profi.com/
    if (l[host] === 'press-profi.com') {
        var el = d[getElementById]('js-preview-news-link')
        var prop_href
        if (el && (prop_href = el[href])) {
            l[replace](prop_href)
        }
    }

    var toprustory_ru = 'toprustory.ru'
    if (l[host] === 'cliclo-info.ru') {
        var params = get_query_params()
        var param_link = params[link]
        if (param_link) {
            if (link[indexOf]('//' + toprustory_ru + '/') >= 0) {
                param_link = param_link[replace](/\?.+$/, '')
            }
            l[replace](param_link)
        }
    }

    // http://toprustory.ru//articles//smi-anna-kalashnikova-sfotografirovalas-obnazhennoy-na-plyazhe-668486?utm_source=mail&utm_content=0&utm_term=668486&utm_campaign=27613300&utm_medium=8207903&customTitle=0JrQsNC70LDRiNC90LjQutC-0LLQsCDQv9C-0LvQvdC-0YHRgtGM0Y4g0YDQsNC30LTQtdC70LDRgdGMINC90LAg0L_Qu9GP0LbQtSDRgdGA0LXQtNC4INC70Y7QtNC10Lkg4oCTINCh0JzQmA&a=30-40&g=1&block=1&cli=592c54529b1c9e63e377d82c
    if (l[host] === toprustory_ru) {
        var loc_path = l[pathname]
        var cleaned_loc_path = loc_path[replace](/\/\//g, '/')
        if (cleaned_loc_path !== loc_path) {
            var new_url = d[createElement]('a')
            new_url[href] = l[toString]()
            new_url[pathname] = cleaned_loc_path
            new_url[search] = 'full=1'
            l[replace](new_url[href])
        }
    }

    if ({
        'blamper.ru'  : true,
        'politfox.ru' : true,
        }[l[host]] &&
        /^(?:\/o)?\/articles/[test](l[pathname]) &&
        !/full=1/[test](l[search])
    ) {
        var new_url = d[createElement]('a')
        new_url[href] = l[toString]()
        new_url[search] = 'full=1'
        l[replace](new_url[href])
    }

    if (l[host] === 'www.vesti.ru') {
        var el = d[querySelector]("a.anons_url")
        if (el) {
            var prop_href = el[href]
            if (prop_href) {
                l[replace](prop_href)
            }
        }
    }

    // https://www.lentainform.com/pnews/6873706/i/324/?utm_campaign=13537686&utm_medium=banner&utm_content=35984983&utm_source=news.mail.ru
    if (l[host] === 'www.lentainform.com') {
        var loc_path = l[pathname]
        var cleaned_loc_path = loc_path[replace](/^\/pnews\//, '/rnews/')
        if (cleaned_loc_path !== loc_path) {
            l[replace](cleaned_loc_path)
        }
    }
})(this)