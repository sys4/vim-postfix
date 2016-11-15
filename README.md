# vim-postfix
The scripts provided in this repository will create vim syntax files for
Postfix.


# Create syntax files
You need to configure three variables in each of the two scripts before they
are able to create syntax files.

```
#!/bin/bash                                                                                                                                                                                        

CAT=/bin/bzcat
POSTCONF1=/usr/share/man/man1/postconf.1.bz2
POSTCONF5=/usr/share/man/man5/postconf.5.bz2

###############################################################################
```

The "CAT" variable should match the "POSTCONF1" and "POSTCONF5" suffix:

    - Set "CAT" to "/bin/cat", if man pages are plain files.
    - Set "CAT" to "/bin/zcat" if man pages are gzip compressed.
    - Set "CAT" to "/bin/bzcat" if man pages are bzip2 compressed.

The paths in `POSTCONF1` and `POSTCONF5` need to match the absolute path to
their corresponding man pages.

Once you've edited the scripts run `./create-pfmain.sh` to create a new
`pfmain.vim` file in the current directory. Then run `./create-pfmaster.sh` for
the `pfmaster.vim` file.


# Install syntax files
vim comes with Postfix syntax highlighting preinstalled. In order to use your
own syntax files you can either copy them over the existing syntax file or install
your own locally.

If you install the new syntax files locally into `$HOME/.vim/syntax` they will
override the global, preinstalled version.


# Enable highlighting
You can use either modelines or an autocommand to enable syntax highlighting.


## modeline
If Vim does not auto highlight `main.cf` or `master.cf` if you open them, add a
modeline at the end of the Postfix configuration files like this for `main.cf`:

```
...

# vim: syn=pfmain.cf:
```
Exchange `pfmain.cf` for `pfmaster.cf` in `master.cf`.


## autocommand
If you don't want to use modelines in vim autocommand is your friend. Create a
`filetype.vim` file in your `$HOME/.vim` directory and add the following lines:

```
" Postfix 
au BufNewFile,BufRead   main.cf     setfiletype pfmain
au BufNewFile,BufRead   master.cf   setfiletype pfmaster
```

Have fun...
