# VIMI

VIMI is a setup of VIM environment to make your VIM more plesant like an IDE.
It is based on **Pathogen** plugins manager and configure automatically your VIM environment. VIMI can be adabted in a very simple way.


### Usage

First use to install and configure your VIM environment
```sh
$ source vimi.bash
```
Several plugins have been prepared for you.
They are listed in plugins.txt in top level directory.
To install new plugins, add a new line, and copy paste the git repo of the plugin target. Then run:
```sh
$ install_plugins
```
Add and modify your shortcuts in shortcuts.vimrc file, then apply:
```sh
$ update_vimrc
```
Ro setup new coding rules, write in clang-format/ directory a clang-format configuration file: mycodingrules.clang-format (the extension must be respected)
Then run:
```sh
$ load_codingrules mycodingrules
$ update_vimrc
```
Don't forget to reload your vim after updating.


### Plugins
Here is the list of default plugins to be installed:

| Plugin | Git repo | Description |
| ------ | ------ | ------ |
| nerdtree |  |File system explorer |
| syntastic |  |Check syntax implementation |
| indentline |  |Display  vertical lines at each indentation level for code indented with spaces |
| quantum.vim |  | Give colorscheme
| delimitMate |  | Close automatically quotes, parenthesis, brackets, etc.|
| vim-floaterm |  | Use vim terminal in the floating/popup window |
| ultisnips |  |
| vim-airline |  | Display statusline & a smarter tabline
| vim-airline-themes |  |
| vim-better-whitespace |  | Highlight & Strip all trailling whitespaces
| vim-cursorline |  | Display the cursor line for the active window only |
| vim-cursorword |  | Underline the word under the cursor
| vim-clang-format |  |


### Requirements
 To use the plugin vim-clang-format you need to install the clang-format tool
 But not indispensable for VIMI


### Installation 
 git clone the repo and run 
 ```sh
$ source vimi.bash
```
