" forked from 
" https://github.com/hut/ranger/blob/master/examples/vim_file_chooser.vim
" https://github.com/Mizuchi/vim-ranger/blob/master/plugin/ranger.vim
" https://github.com/airodactyl/neovim-ranger

function! s:VifmCall(dirname, callbacks, mode, prev)
    let tempfile = tempname()
    call termopen(['vifm',
                \ '--choose-files', tempfile,
                \ a:dirname], extend({
                \ 'tempfile': tempfile,
                \ 'mode': a:mode,
                \ 'prev': a:prev,
                \ }, a:callbacks))
    startinsert
endfunction

function! s:VifmCallWithMode(dirname, callbacks, mode)
    if a:mode == 'split'
        let prev = winnr()
    else
        let prev = bufnr('%')
    endif
    if a:mode == 'split'
        exe 'topleft ' . g:vifmSplitWidth . 'vnew'
    endif
    call s:VifmCall(a:dirname, a:callbacks, a:mode, prev)
endfunction

function! Vifm(dirname)
    if a:dirname != '' && isdirectory(a:dirname)
        let winnum = s:VifmWinNum()
        if winnum == 0
            let callbacks = { 'on_exit': function('s:VifmExitCallback') }
            call s:VifmCallWithMode(a:dirname, callbacks, 'split')
        else
            exe winnum . 'wincmd w'
            startinsert
        endif
    endif
endfunction

function! VifmNoSplit(dirname)
    if a:dirname != '' && isdirectory(a:dirname)
        if !s:VifmInThisBuf()
            let callbacks = { 'on_exit': function('s:VifmExitCallback') }
            call s:VifmCallWithMode(a:dirname, callbacks, 'auto')
        endif
    endif
endfunction

function! s:VifmBufferCheck(bufnum)
    let bufstr = bufname(a:bufnum)
    return matchstr(bufstr, '^term:\/\/.*:vifm$') != ''
endfunction

function! s:VifmExitCallback(job_id, data, event)
    if !filereadable(self.tempfile)
        return
    endif
    let names = readfile(self.tempfile)
    if empty(names)
        return
    endif
    if self.mode == 'split'
        call VifmClose(self.mode, self.prev)
    else
        call VifmClose(self.mode, self.prev)
    endif
    exec 'edit ' . fnameescape(names[0])
    for name in names[1:]
        exec 'tabedit ' . fnameescape(name)
        filetype detect
    endfor
endfunction

function! s:VifmBufNum()
    let bufnums = tabpagebuflist()
    for bufnum in bufnums
        if s:VifmBufferCheck(bufnum)
            return bufnum
        endif
    endfor
    return -1
endfunction

function! s:VifmWinNum()
    let bufnum = s:VifmBufNum()
    if bufnum == -1
        return 0
    else
        return bufwinnr(bufnum)
    endif
endfunction

function! s:VifmInThisBuf()
    return s:VifmBufferCheck(bufnr('%'))
endfunction

function! s:VifmJumpBack(mode, prev)
    if a:prev == -1
        return 0
    endif
    if a:mode == 'split'
        silent! exe a:prev . 'wincmd w'
    else
        silent! buffer a:prev
    endif
    return 1
endfunction

function! VifmClose(...)
    if a:0 > 0
        let mode = a:1
    else
        let mode = 'split'
    endif
    if a:0 > 1
        let prev = a:2
    else
        let prev = -1
    endif
    if s:VifmInThisBuf()
        if mode == 'split'
            bdelete!
            call s:VifmJumpBack(mode, prev)
        else
            let bufnum = bufnr('%')
            bprev
            call s:VifmJumpBack(mode, prev)
            exe 'silent! bdelete! ' . bufnum
        endif
        return
    else
        let bufnum = s:VifmBufNum()
        if bufnum == -1
            return
        else
            exe 'bdelete! ' . bufnum
        endif
    endif
endfunction

function! s:VifmAuto(dirname)
    if a:dirname != '' && isdirectory(a:dirname)
        " bdelete!
        call VifmNoSplit(a:dirname)
    endif
endfunction

if exists('g:vifmSplitWidth') && !(type (g:vifmSplitWidth) != 0)
    echoerr 'neovim-vifm: g:vifmSplitWidth must be an integer.'
endif
if !exists('g:vifmSplitWidth')
    let g:vifmSplitWidth = 40
endif

let g:loaded_netrwPlugin = 'disable'
au BufEnter * silent call s:VifmAuto(expand('<amatch>'))

command! -complete=file -nargs=1 Vifm call Vifm(<f-args>)
