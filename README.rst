neovim-vifm
==========

neovim-ranger is Copyright (C) 2015 Tianjiao Yin <ytj000@gmail.com>

with fixes for neovim by Michael Hoang <enzime@users.noreply.github.com>

User Guide
----------

`vifm <http://vifm.info/>`_ is a file manager with vim key bindings.
While ranger is vim-like in philosophy, vifm seeks to emulate vim as completely as possible in a file manager.

This plugin is similar to `nerdtree <https://github.com/scrooloose/nerdtree>`_. 
It overrides the default file browser (netrw), so if you :edit a directory a vifm will be opened. 
When you open a file in vifm, it will be opened in neovim.
You could also select multiple files and open'em all at once (use ``v`` to select multiple files in vifm).
BTW, don't use it with nerdtree at the same time. 

Requirement
------------

neovim

vifm >= 0.8 beta

Tips
-----

Add ``nnoremap <f9> :tabe %:p:h<cr>`` to your nvimrc, so that you could use ``<f9>`` to open new files in new tab.

Known issues
-----------

1. After closing vifm, the prompt waiting for a key press is displayed. This can't be bypassed, and will hopefully be fixed by neovim-0.2. (airodatyl's note may no longer apply)

Notes
-----

airodactyl's plugin is forked from the official ranger example here:
https://github.com/hut/ranger/blob/master/examples/vim_file_chooser.vim

airodactyl's plugin is located here:
https://github.com/airodactyl/neovim-ranger

I have not officially forked the original repository and have instead created my own repository because this is not viable as an alternative to the original or suitable for a pull request.
I also plan to add many features in the future, such as nerd tree style drawer functionality (sorry tpope).

There are 2 main differences between this and the official ranger example.

1. Unlike the original plugin, in airodactyl's plugin the files are opened in tabs instead of buffers.
2. vifm will be opened automatically when you :edit a directory. The original plugin requires to execute a vim command to open the file manager.
