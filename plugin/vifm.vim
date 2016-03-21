" forked from 
" https://github.com/hut/ranger/blob/master/examples/vim_file_chooser.vim
" https://github.com/Mizuchi/vim-ranger/blob/master/plugin/ranger.vim
" https://github.com/airodactyl/neovim-ranger

function! s:VifmMagic(dirname)
    if exists('g:vifmed')
        let vifmed = g:vifmed
        unlet g:vifmed

        if !filereadable(vifmed)
            return
        endif

        let names = readfile(vifmed)

        if empty(names)
            return
        endif

        exec 'edit ' . fnameescape(names[0])
        filetype detect

        for name in names[1:]
            exec 'tabe ' . fnameescape(name)
            filetype detect
        endfor
    elseif isdirectory(a:dirname)
        let g:vifmed = tempname()
        exec 'terminal vifm --choose-files ' . shellescape(g:vifmed) . ' ' . shellescape(a:dirname)
    endif
endfunction

au BufEnter * silent call s:VifmMagic(expand("<amatch>")) 
let g:loaded_netrwPlugin = 'disable'
