neovim-vifm
==========

Integration between `vifm <https://github.com/vifm/vifm>`_ (the vi file manager) and neovim/vim 8.

Requirements
------------

neovim or vim >= 8

vifm >= 0.8 beta

About the Plugin
----------------

`vifm <http://vifm.info/>`_ is a file manager with vim key bindings.
While ranger is a file manager that is vim-like in philosophy, vifm seeks to emulate vim as completely as possible in a file manager.
It feels extremely natural in vim.

This plugin is similar to `NERDTree <https://github.com/scrooloose/nerdtree>`_. 
It overrides the default file browser (netrw), so if you :edit a directory a vifm will be opened. 
When you open a file in vifm, it will be opened back in vim.
It also replaces netrw, the default vim file manager.
You can also select multiple files and open them all at once (use ``v``/``t`` to select multiple files in vifm).

Do not use this plugin at the same time as NERDTree or the official vifm plugin.

Usage
-----

See `:help neovim-vifm` for usage information.

Notes
-----

neovim-vifm was written by Roger Bongers.
This project was forked from `neovim-ranger <https://github.com/airodactyl/neovim-ranger>`_, by Michael Hoang <enzime@users.noreply.github.com>.
The `original plugin <https://github.com/hut/ranger/blob/master/examples/vim_file_chooser.vim>`_ is Copyright (C) 2015 Tianjiao Yin <ytj000@gmail.com>.

I have not officially forked the original repository and have instead created my own repository because this is not viable as an alternative to the original or suitable for a pull request.
I have also significantly altered the program.
