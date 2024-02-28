function! AtbashDecode(cipher) abort
    let str = tolower(substitute(a:cipher, '[^[:alnum:]]', '', 'g'))
    let str = tr(str, 'abcdefghijklmnopqrstuvwxyz', 'zyxwvutsrqponmlkjihgfedcba')
    return str
endfunction

function! AtbashEncode(plaintext) abort
    let str = AtbashDecode(a:plaintext)
    " let str = substitute(str, '.\{5\}', '& ', 'g')
    " return substitute(str, ' $', '', '')
