# vim-postfix
vim Syntax Highlighting for Postfix

# Configuration
Edit both create-scripts and adopt the first two variables to your needs.

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
