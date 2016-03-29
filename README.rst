neovim-vifm
==========

Integration between `vifm <https://github.com/vifm/vifm>`_ (the vi file manager) and neovim.

Requirements
------------

neovim

vifm >= 0.8 beta

About the Plugin
----------------

`vifm <http://vifm.info/>`_ is a file manager with vim key bindings.
While ranger is a file manager that is vim-like in philosophy, vifm seeks to emulate vim as completely as possible in a file manager.
It feels extremely natural in neovim.

This plugin is similar to `NERDTree <https://github.com/scrooloose/nerdtree>`_. 
It overrides the default file browser (netrw), so if you :edit a directory a vifm will be opened. 
When you open a file in vifm, it will be opened back in neovim.
It also replaces netrw, the default vim file manager.
You can also select multiple files and open them all at once (use ``v``/``t`` to select multiple files in vifm).

Do not use this plugin at the same time as NERDTree or the official vifm plugin.

Usage
-----

To launch vifm in a sidepane, run ``:Vifm {folder}``.
In addition, any time a folder is opened using any command (such as ``:edit {folder}``), vifm will open.

When a file is opened in vifm, it will be opened in vim.

You can perform rudimentary navigation using ``hjkl``.
Files can be opened with ``:edit`` or by pressing ``l`` while the cursor is over a file.
When a non-folder file is opened in vifm, the buffer will exit and the plugin will attempt to open it in the window vifm was invoked from, or the closest window if it does not exist.
To exit vifm without opening anything, enter ``:q`` or ``ZZ``.
vifm has many, many other features, which you can read about in .vifm/vifm-help.txt
The power of properly learning and configuring vifm, just as you would vim, cannot be overstated.

Configuration
-------------

Set the variable `g:vifmSplitWidth` to configure the width of the vifm side-menu.

Set the variable `g:vifmLiveCwd` to 1 to allow vifm to alter the active directory as it navigates.

Notes
-----

neovim-vifm was written by Roger Bongers.
This project was forked from `neovim-ranger <https://github.com/airodactyl/neovim-ranger>`_, by Michael Hoang <enzime@users.noreply.github.com>.
The `original plugin <https://github.com/hut/ranger/blob/master/examples/vim_file_chooser.vim>`_ is Copyright (C) 2015 Tianjiao Yin <ytj000@gmail.com>.

I have not officially forked the original repository and have instead created my own repository because this is not viable as an alternative to the original or suitable for a pull request.
I have also significantly altered the program.
