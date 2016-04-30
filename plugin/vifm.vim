" forked from
" https://github.com/hut/ranger/blob/master/examples/vim_file_chooser.vim
" https://github.com/Mizuchi/vim-ranger/blob/master/plugin/ranger.vim
" https://github.com/airodactyl/neovim-ranger

function! s:vifmGetVar(var, type, default)
    if exists(a:var)
        if  eval('type (' . a:var . ')') != a:type
            echoerr 'neovim-vifm: ' . a:var . ' must be type ' . string(a:type)
        else
            return eval(a:var)
        endif
    endif
    return a:default
endfunction

function! s:vifmGetSplitWidth()
    return s:vifmGetVar('g:vifmSplitWidth', 0, 40)
endfunction

function! s:vifmGetUseCurrent()
    return s:vifmGetVar('g:vifmUseCurrent', 0, 1)
endfunction

function! s:vifmGetLiveCwd()
    return s:vifmGetVar('g:vifmLiveCwd', 0, 0)
endfunction

function! s:vifmGetUseLcd()
    return s:vifmGetVar('g:vifmUseLcd', 0, 0)
endfunction

function! s:VifmCwdCall(dirfile)
    let command = ['bash', '-c', 'while true; do cat ' . shellescape(a:dirfile) . '; done']
    let argdict = {}
    let callbacks = { 'on_stdout': function('s:VifmCwdStdoutCallback') }
    let job = jobstart(command, extend(argdict, callbacks))
    return job
endfunction

function! s:VifmCall(dirname, mode, prev)
    let listfile = tempname()
    let command = ['vifm', '--choose-files', listfile ]
    let vifmUseCurrent = s:vifmGetUseCurrent()
    if vifmUseCurrent
        let command = command + [a:dirname]
    endif
    let argdict = {
                \ 'listfile': listfile,
                \ 'mode': a:mode,
                \ 'prev': a:prev,
                \ }
    let callbacks = { 'on_exit': function('s:VifmExitCallback') }
    let vifmLiveCwd = s:vifmGetLiveCwd()
    if vifmLiveCwd == 1
        let dirfile = tempname()
        silent exec '!mkfifo ' . dirfile
        let cwd_job = s:VifmCwdCall(dirfile)
        let argdict.dirfile = dirfile
        let argdict.cwd_job = cwd_job
        call add(command, '-c')
        call add(command, 'autocmd DirEnter * !pwd >> ' . dirfile)
        call add(command, '--choose-dir')
        call add(command, dirfile)
    endif
    call termopen(command, extend(argdict, callbacks))
    startinsert
endfunction

function! s:VifmCallWithMode(dirname, mode)
    if a:mode == 'split'
        let prev = winnr()
    else
        let prev = bufnr('%')
    endif
    let vifmSplitWidth = s:vifmGetSplitWidth()
    if a:mode == 'split'
        exe 'topleft ' . vifmSplitWidth . 'vnew'
    endif
    call s:VifmCall(a:dirname, a:mode, prev)
endfunction

function! Vifm(dirname)
    if a:dirname != '' && isdirectory(a:dirname)
        let winnum = s:VifmWinNum()
        if winnum == 0
            call s:VifmCallWithMode(a:dirname, 'split')
        else
            exe winnum . 'wincmd w'
            startinsert
        endif
    endif
endfunction

function! VifmNoSplit(dirname)
    if a:dirname != '' && isdirectory(a:dirname)
        if !s:VifmInThisBuf()
            call s:VifmCallWithMode(a:dirname, 'auto')
        endif
    endif
endfunction

function! s:VifmBufferCheck(bufnum)
    let bufstr = bufname(a:bufnum)
    return matchstr(bufstr, '^term:\/\/.*:vifm$') != ''
endfunction

function! s:VifmCwdStdoutCallback(job_id, data, event)
    if s:vifmGetUseLcd()
        exec 'lcd ' . fnameescape(a:data[0])
    else
        exec 'cd ' . fnameescape(a:data[0])
    endif
endfunction

function! s:VifmExitCallback(job_id, data, event)
    if exists('self.cwd_job')
        call jobstop(self.cwd_job)
    endif
    if !filereadable(self.listfile)
        return
    endif
    let names = readfile(self.listfile)
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

let g:loaded_netrwPlugin = 'disable'
au BufEnter * silent call s:VifmAuto(expand('<amatch>'))

command! -complete=file -nargs=1 Vifm call Vifm(<f-args>)
