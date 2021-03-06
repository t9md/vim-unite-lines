" Unite source lines {{{
" original verion is http://d.hatena.ne.jp/thinca/20101105/1288896674

call unite#util#set_default('g:unite_source_lines_highlight', 1)
call unite#util#set_default('g:unite_source_lines_highlight_color',
            \ "gui=bold ctermfg=255 ctermbg=4 guifg=#ffffff guibg=#0a7383" )

let s:unite_source = {}
let s:unite_source.syntax = "uniteSource_Lines"
let s:unite_source.hooks = {}
let s:unite_source.name = 'lines'

function! s:unite_source.hooks.on_syntax(args, context) "{{{
  call s:hl_refresh(a:context)
endfunction"}}}


function! s:hl_refresh(context)
    if !hlexists("uniteSource_Lines_target")
        exe "highlight uniteSource_Lines_target " . g:unite_source_lines_highlight_color
    endif
    syntax clear uniteSource_Lines_target
    if a:context.input == '' || !g:unite_source_lines_highlight
        return
    endif

    for word in split(a:context.input, '\\\@<! ')
        execute "syntax match uniteSource_Lines_target '"
          \ . unite#escape_match(word)
          \ . "' containedin=uniteSource_Lines"
    endfor
endfunction

function! s:unite_source.gather_candidates(args, context)
    let path = expand('%:p')
    let lines = getbufline('%', 1, '$')
    let format = '%' . strlen(len(lines)) . 'd: %s'
    return map(lines, '{
                \   "word": printf("%s", v:val),
                \   "abbr": printf(format, v:key + 1, v:val),
                \   "source": "lines",
                \   "kind": "jump_list",
                \   "action__path": path,
                \   "action__line": v:key + 1,
                \ }')
endfunction

function! s:unite_source.hooks.on_post_filter(args, context)
    call s:hl_refresh(a:context)
endfunction

function! s:unite_source.hooks.on_close(args, context)
    if !g:unite_source_lines_highlight | return | endif
    exe "syntax clear uniteSource_Lines_target"
    exe "highlight clear uniteSource_Lines_target"
endfunction

function! unite#sources#lines#define() "{{{
  return s:unite_source
endfunction "}}}

" call unite#define_source(s:unite_source)
" unlet s:unite_source
" }}}
" vim: expandtab:ts=4:sts=4:sw=4
