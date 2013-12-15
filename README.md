Surround TextObject
-------------------

In vim, one can quickly delete or change the text surrounded by parentheses and
quotes using motion and text-objects. For example, `di'` will delete the text
between two `'`s, and `da"` will delete the string between two `"`s alongwith
the surrounding quotes. This plugin simulates similar text-object motion for
many other symbols.

After installing this plugin, you can, for instance, delete the text between
two `$`s by typing `di$`. However, its counterpart `da$` is a little bit
different from that of quotes and parentheses. Command `da$` will only delete
one of the two `$`s instead of both of them. This behavior is intentional. The
reason is that `da`_symbol_ can be used to delete _symbol_-delimited fields.
For example, when cursor is placed inside `long` in
`underscore_delimited_long_variable`, typing `da_` will change the string to
`underscore_delimited_variable` instead of `underscore_delimitedvariable`.

The symbols to be included can be changed by setting
`g:surround_textobj_symbols` to a string containing desired symbols in
`~/.vimrc`. The default setting is

```vim
let g:surround_textobj_symbols = '~!@#$%^&*_-+=;:/?.,'
```

### Copyright

This plugin is distributed under the terms of the Vim license. See
`:help license` for the full text of the license.
