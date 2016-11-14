# vim-postfix
vim Syntax Highlighting for Postfix

# Configuration
Edit both create-scripts and adopt the first three variables to your needs. The
"CAT" variable should match the "POSTCONF1" and "POSTCONF5" suffix.

- Set "CAT" to "/bin/cat", if man pages are plain files.
- Set "CAT" to "/bin/zcat" if man pages are gzip compressed.
- Set "CAT" to "/bin/bzcat" if man pages are bzip2 compressed.

- "POSTCONF1" should match the absolute path for the man page postconf(1)
- "POSTCONF5" should match the absolute path for the man page postconf(5)

# Run the scripts
Run "./create-pfmain.sh" to create a new pfmain.vim file in the current
directory. Run "./create-pfmaster.sh" for the pfmaster.vim file.

# Copy files
Put both vim-files into $HOME/.vim/syntax (create the directory, if it does not
yet exist).

# Adding a  modeline
If Vim does not auto highlight the files, add a modeline at the end of the
Postfix configuration files.

- For the "main.cf" it should contain: vim: syn=pfmain.cf
- For the "master.cf" it should contain: vim: syn=pfmaster.cf

Have fun...
