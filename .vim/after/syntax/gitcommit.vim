syn match   gitcommitSummary    "^.*\%<72v." contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
hi def link gitcommitOverflow       Underlined

setlocal textwidth=70
setlocal colorcolumn=+1

