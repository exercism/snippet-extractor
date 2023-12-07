require "test_helper"

class SnippetExtractor::Languages::VimscriptTest < Minitest::Test
  def test_full_example
    code = <<~'CODE'
      "
      " Create an implementation of the atbash cipher, an ancient encryption system
      " created in the Middle East.
      "
      " Examples:
      "
      "   :echo AtbashEncode('test')
      "   gvhg
      "
      "   :echo AtbashDecode('gvhg')
      "   test
      "
      "   :echo AtbashDecode('gsvjf rxpyi ldmul cqfnk hlevi gsvoz abwlt')
      "   thequickbrownfoxjumpsoverthelazydog
      "

      function! AtbashDecode(cipher) abort
          let str = tolower(substitute(a:cipher, '[^[:alnum:]]', '', 'g'))
          let str = tr(str, 'abcdefghijklmnopqrstuvwxyz', 'zyxwvutsrqponmlkjihgfedcba')
          return str
      endfunction

      function! AtbashEncode(plaintext) abort
          let str = AtbashDecode(a:plaintext)
          " let str = substitute(str, '.\{5\}', '& ', 'g')
          " return substitute(str, ' $', '', '')
          return join(split(str, '.\{5\}\zs'), ' ')
      endfunction
    CODE

    expected = <<~'CODE'

      function! AtbashDecode(cipher) abort
          let str = tolower(substitute(a:cipher, '[^[:alnum:]]', '', 'g'))
          let str = tr(str, 'abcdefghijklmnopqrstuvwxyz', 'zyxwvutsrqponmlkjihgfedcba')
          return str
      endfunction

      function! AtbashEncode(plaintext) abort
          let str = AtbashDecode(a:plaintext)
          " let str = substitute(str, '.\{5\}', '& ', 'g')
    CODE
    assert_equal expected, SnippetExtractor::ExtractSnippet.(code, :vimscript)
  end
end
