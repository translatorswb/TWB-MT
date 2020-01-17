# -*- coding: utf-8 -*-
import re
import regex
import sys
import getopt
import os
import csv

def help():
  print """Usage: {0} [options] [input [output]]
  Optional parameters:
    input                input file
    output               output file
  Options:
    -s, --stats=file     file to store a csv with the stats
    -l, --language=lang  language of the file
    -h, --help           shows this help
    """.format(os.path.basename(sys.argv[0]))

# remove annoying characters
chars = {
    '\xe2\x80\xa2': '',      # bullet •
    '\xe2\x80\xa8': ' ',      # line separator

    '\x0d'     : "",         # \r
    #'\x60'     : "'",        # grave accent
    '\xc5\xa5' : "t'",       # latin small letter t with caron ť

    '\xc6\x92' : "f",        # latin small letter f with hook ƒ

    '\xcb\x86' : '',         # modifier letter circumflex accent ˆ
    '\xcb\x87' : '',         # caron ˇ
    '\xcb\x9c' : '',         # small tilde ˜

    '\xc2\x82' : ',',        # High code comma
    '\xc2\x84' : ',,',       # High code double comma
    '\xc2\x85' : '...',      # Tripple dot
    '\xe2\x80\xa6' : '...',  # Tripple dot
    '\xc2\x88' : '^',        # High carat
    '\xc2\x91' : '\x27',     # Forward single quote
    '\xc2\x92' : '\x27',     # Reverse single quote
    '\xc2\x93' : '\x22',     # Forward double quote
    '\xc2\x94' : '\x22',     # Reverse double quote
    '\xc2\x95' : ' ',
    '\xc2\x96' : '',         # High hyphen
    '\xc2\x97' : '',         # Double hyphen
    '\xc2\x99' : ' ',
    '\xc2\xa0' : ' ',
    '\xc2\xa4' : '',         # currency sign ¤
    '\xc2\xa6' : '|',        # Split vertical bar ¦
    '\xc2\xa7' : '',         # section sign §
    '\xc2\xa8' : '',         # diaeresis ¨
    '\xc2\xa9' : '',         # Copyright sign  ©
    '<<'       : '«',        # less-than sign
    ##'\xc2\xab' : '<<',       # Double less than
    '\xc2\xae' : '',         # Registered sign
    '\xc2\xac' : '',         # not sign ¬
    '\xc2\xad' : '-',         # soft hyphen
    '\xc2\xaf' : '-',        # macron ¯
    '\xc2\xb0' : '\xc2\xba', # degree sign
    '\xc2\xb4' : "'",        # acute accent
    '\xc2\xb6' : "",         # pilcrow sign ¶
    ##'\xc2\xbb' : '>>',       # Double greater than
    '>>' : '»',              # greater-than sign
    '\xc2\xbc' : '1/4',      # one quarter
    '\xc2\xbd' : '1/2',      # one half
    '\xc2\xbe' : '3/4',      # three quarters

    '\xc3\x98' : '',         # latin capital letter o with stroke Ø
    '\xc3\xb8' : '',         # latin small letter o with stroke ø

    '\xc3\x90' : '',         # latin letter eth Ð
    '\xc3\xb0' : '',         # latin small letter eth ð

    '\xc4\xa6' : 'H',        # latin capital letter H with stroke Ħ
    '\xc4\xa7' : 'h',        # latin small letter h with stroke ħ

    '\xc4\xbb' : "'",        # modifier letter turned comma ʻ

#    '\xca\xbf' : '\x27',     # c-single quote
    '\xcc\xa8' : '',         # modifier - under curve
    '\xcc\xb1' : '',         # modifier - under line

    '\xd9\xad' : '',         # arabic five pointed star ٭

    '\xe0\xa4\x82': '',      # devanagari sign anusvara ं

    '\xe1\xb5\x92': 'º',     # modifier letter small o ᵒ
    '\xe1\x82\xbe': '',      # georgian capital letter xan Ⴞ

    '\xe2\x8c\x88': '',      # left ceiling ⌈
    '\xe2\x8c\x89': '',      # right ceiling ⌉
    '\xe2\x8c\x8a': '',      # left floor ⌊
    '\xe2\x8c\x8b': '',      # right floor ⌋
    '\xe2\x8c\xa5': '',      # option key ⌥

    '\xe2\x80\x82': " ",     # en space
    '\xe2\x80\x83': " ",     # em space
    '\xe2\x80\x89': " ",     # thin space

    '\xe2\x80\x90': "-",     # hyphen ‐
    '\xe2\x80\x91': "-",     # non-breaking hyphen ‑
    '\xe2\x80\x92': "-",     # figure dash ‒
    '\xe2\x80\x93': '-',     # en dash –
    '\xe2\x80\x94': '-',     # em dash —
    '\xe2\x80\x95': "-",     # horizontal bar ―
    #'\xe2\x80\x98': "'",     # left single quotation mark ‘
    #'\xe2\x80\x99': "'",     # right single quotation mark ’
    #'\xe2\x80\x9a': ',',     # single low-9 quotation mark ‚
    #'\xe2\x80\x9b': "'",     # single high-reversed-9 quotation mark ‛
    #'\xe2\x80\x9c': '"',     # left double quotation mark “
    #'\xe2\x80\x9d': '"',     # right double quotation mark ”
    #'\xe2\x80\x9e': '"',     # double low-9 quotation mark „
    #'\xe2\x80\x9f': '"',     # double high-reversed-9 quotation mark ‟

    '\xe2\x80\xa0': '',      # dagger †
    '\xe2\x80\xa1': '',      # double dagger ‡
    '\xe2\x80\xa2': '',      # bullet •
    '\xe2\x80\xa8': '',      # line separator
    '\xe2\x80\xa9': ' ',     # paragraph separator
    '\xe2\x80\xaa': '',      # left-to-right embedding (not a printable character)
    '\xe2\x80\xab': '',      # right-to-left embedding (not a printable character)
    '\xe2\x80\xac': '',      # pop-directional formatting (not a printable character)
    '\xe2\x80\xad': '',      # left-to-right override (not a printable character)
    '\xe2\x80\xae': '',      # right-to-left override (not a printable character)
    '\xe2\x80\xaf': '',      # narrow no-break space (not a printable character)

    '\xe2\x80\xb2': "'",     # prime
    '\xe2\x80\xb3': "''",    # double prime
    '\xe2\x80\xb4': "'''",   # triple prime
    '\xe2\x80\xb9': '<',     # single left-pointing angle quotation mark ‹
    '\xe2\x80\xba': '>',     # single right-pointing angle quotation mark ›
    '\xe2\x80\xbe': '-',     # overline ‾

    '\xe2\x81\xaa': '',      # inhibit symmetric swapping (not a printable character)
    '\xe2\x81\xb0': 'º',     # superscript zero

    '\xe2\x82\xab': '',      # dong sign
    '\xe2\x82\xbb': '',      # not assigned (not a printable character)

    '\xe2\x84\x93': 'l',     # script small l ℓ

    '\xe2\x84\x96': 'Nº',    # numero sign №
    '\xe2\x84\xa2': '',      # trade mark sign ™

    '\xe2\x85\xa1': 'II',    # roman numeral two Ⅱ

    '\xe2\x86\x90': '<-',    # leftwards arrow ←
    '\xe2\x86\x91': '',      # upwards arrow ↑
    '\xe2\x86\x92': '->',    # rightwards arrow →
    '\xe2\x86\x93': '',      # downwards arrow ↓
    '\xe2\x86\x94': '<->',   # left right arrow ↔
    '\xe2\x86\x95': '',      # up down arrow ↕
    '\xe2\x86\xb5': '<-',    # downwards arrow with corner leftwards ↵


    '\xe2\x87\x95': '',      # up down double arrow ⇕
    '\xe2\x87\xa6': '<-',    # leftwards white arrow ⇦
    '\xe2\x87\xa7': '',      # upwards white arrow ⇧
    '\xe2\x87\xa8': '->',    # rightwards white arrow ⇨
    '\xe2\x87\xa9': '',      # downwards white arrow ⇧

    '\xe2\x88\x82': '',      # partial differential ∂
    '\xe2\x88\x85': '',      # empty set ∅
    '\xe2\x88\x8e': '',      # end of proof ∎
    '\xe2\x88\x8f': '',      # n-ary product ∏
    '\xe2\x88\x9a': '',      # square root √
    '\xe2\x88\x92': '-',     # minus sign −
    '\xe2\x88\x97': '*',     # asterisk operator ∗
    '\xe2\x88\xab': '',      # integral ∫


    '\xe2\x89\xa1': '=',     # identical to
    '\xe2\x89\xa4': '<=',    # less-than or equal to ≤
    '\xe2\x89\xa5': '>=',    # greater-than or equal to ≥

    '\xe2\x8a\x97': '',      # circled times ⊗
    '\xe2\x8e\xa8': '{',     # left curly bracket middle piece ⎨
    '\xe2\x8e\xac': '}',     # right curly bracket middle piece ⎬

    '\xe2\x8c\x98': '',      # place of interest sign ⌘

    '\xe2\x8c\xab': '',      # erase to the left ⌫

    '\xe2\x8e\x9d': ' ',     # left parenthesis lower hook ⎝

    '\xe2\x8e\xa1': '',      # left square bracket upper corner ⎡
    '\xe2\x8e\xa2': '',      # left square bracket extension ⎢
    '\xe2\x8e\xa3': '',      # left square bracket lower corner ⎣
    '\xe2\x8e\xa4': '',      # right square bracket upper corner ⎤
    '\xe2\x8e\xa5': '',      # right square bracket extension ⎥
    '\xe2\x8e\xa6': '',      # right square bracket lower corner ⎦

    '\xe2\x91\xa0': '',      # circled digit one ①

    '\xe2\x94\x80': '-',     # box drawings light horizontal ─
    '\xe2\x94\x82': '|',     # box drawings light vertical │

    '\xe2\x96\x80': '',      # upper half block ▀

    '\xe2\x96\xa0': '',      # black square ■
    '\xe2\x96\xa1': '',      # white square □
    '\xe2\x96\xaa': '',      # black small square ▪
    '\xe2\x96\xba': '',      # black right-pointing pointer ►
    '\xe2\x96\xbc': '',      # black down-pointing triangle ▼
    '\xe2\x96\xb2': '',      # black up-pointing triangle ▲
    '\xe2\x96\xb6': '',      # black right-pointing triangle ▶

    '\xe2\x97\x80': '',      # black left-pointing triangle ◀
    '\xe2\x97\x84': '',      # black left-pointing pointer ◄
    '\xe2\x97\x8a': '',      # lozenge ◊
    '\xe2\x97\x8b': '',      # white circle ○
    '\xe2\x97\x8f': '',      # black circle ●

    '\xe2\x90\xa1': '',      # symbol for delete


    '\xe2\x98\x85': '',      # black star ★
    '\xe2\x98\xba': '',      # white smiling face ☺


    '\xe2\x99\xa0': '',      # black spade suit ♠
    '\xe2\x99\xa3': '',      # black club suit ♣
    '\xe2\x99\xa5': '',      # black heart suit ♥
    '\xe2\x99\xa6': '',      # black diamond suit ♦
    '\xe2\x99\xaa': '',      # eighth note ♪
    '\xe2\x99\xab': '',      # beamed eighth notes ♫
    'âª'      : '',      # bad encoded note
    'Âª'      : '',      # bad encoded note

    '\xe2\xa1\x83': '',      # braille pattern dots-127 ⡃

    '\xe2\xa6\xbe': '',      # circled white bullet ⦾

    '\xe2\xac\x84': '',      # left right white arrow ⬄

    '\xe3\x80\x8c': '',      # left corner bracket  「
    '\xe3\x80\x8d': '',      # right corner bracket   」


    '\xe4\x95\x93': '',      # cjk unified ideograph-4553 䕓

#unicode ligatures
    '\xef\xac\x80': 'ff',
    '\xef\xac\x81': 'fi',
    '\xef\xac\x82': 'fl',
    '\xef\xac\x83': 'ffi',
    '\xef\xac\x84': 'ffl',
    '\xef\xac\x86': 'st',

    '&nbsp;'  : " ",
    '&lt;'    : "<",
    '&gt;'    : ">",
    '&amp;'   : "&",
    '&quot;'  : '"',
    '&apos;'  : "'",
    '&iexcl;' : '¡',
    '&cent;'  : '¢',
    '&pound;' : '£',
    '&curren;': '',      # ¤
    '&yen;'   : '¥',
    '&brvbar;': '',      # ¦
    '&sect;'  : '',      # §
    '&uml;'   : '',      # ¨
    '&copy;'  : '',      # ©
    '&ordf;'  : 'ª',     # ª
    '&laquo;' : '«',
    '&not;'   : '',      # ¬
    '&shy;'   : '',
    '&reg;'   : '',      # ®
    '&hibar;' : '-',     # ¯
    '&macr;'  : '-',
    '&deg;'   : 'º',     # °
    '&plusmn;': '±',
    '&sup2;'  : '²',     # ²
    '&sup3;'  : '³',     # ³
    '&acute;' : "'",     # ´
    '&micro;' : 'µ',     # µ
    '&para;'  : '',      # ¶
    '&middot;': '·',     # ·
    '&cedil;' : ',',     # ¸
    '&sup1;'  : '¹',     # ¹
    '&ordm;'  : 'º',     # º
    '&raquo;' : '»',     # »
    '&frac14;': '1/4',   # ¼
    '&frac12;': '1/2',   # ½
    '&frac34;': '3/4',   # ¾
    '&iquest;': '¿',     # ¿

    '&Agrave;': 'À',
    '&Aacute;': 'Á',
    '&Acirc;' : 'Â',
    '&Atilde;': 'Ã',
    '&Auml;'  : 'Ä',
    '&Aring;' : 'Å',
    '&Aelig;' : 'Æ',

    '&agrave;': 'à',
    '&aacute;': 'á',
    '&acirc;' : 'â',
    '&atilde;': 'ã',
    '&auml;'  : 'ä',
    '&aring;' : 'å',
    '&aelig;' : 'æ',

    '&Ccedil;': 'Ç',
    '&ccedil;': 'ç',

    '&Egrave;': 'È',
    '&Eacute;': 'É',
    '&Ecirc;' : 'Ê',
    '&Euml;'  : 'Ë',

    '&egrave;': 'è',
    '&eacute;': 'é',
    '&ecirc;' : 'ê',
    '&euml;'  : 'ë',

    '&Igrave;': 'Ì',
    '&Iacute;': 'Í',
    '&Icirc;' : 'Î',
    '&Iuml;'  : 'Ï',

    '&igrave;': 'ì',
    '&iacute;': 'í',
    '&icirc;' : 'î',
    '&iuml;'  : 'ï',

    '&Eth;'   : '',   #Ð
    '&eth;'   : '',   #ð

    '&Ntilde;': 'Ñ',
    '&ntilde;': 'ñ',

    '&Ograve;': 'Ò',
    '&Oacute;': 'Ó',
    '&Ocirc;' : 'Ô',
    '&Otilde;': 'Õ',
    '&Ouml;'  : 'Ö',

    '&ograve;': 'ò',
    '&oacute;': 'ó',
    '&ocirc;' : 'ô',
    '&otilde;': 'õ',
    '&ouml;'  : 'ö',

    '&times;' : '×',   # ×
    '&Oslash;': '',    # Ø
    '&oslash;': '',    # ø

    '&Ugrave;': 'Ù',
    '&Uacute;': 'Ú',
    '&Ucirc;' : 'Û',
    '&Uuml;'  : 'Ü',

    '&ugrave;': 'ù',
    '&uacute;': 'ú',
    '&ucirc;' : 'û',
    '&uuml;'  : 'ü',

    '&Yacute;': 'Ý',
    '&yacute;': 'ý',
    '&yuml;'  : 'ÿ',   # ÿ
    '&Yuml;'  : 'Ÿ',   # capital Y with diaeres	Ÿ

    '&thorn;' : 'Þ',   # þ
    '&szlig;' : 'ß',   # ß

    '&divide;': '÷',   # ÷

    '&euro;'  : '€',

    '&forall;': '∀', # for all ∀
    '&part;'  : '∂', # part ∂
    '&exist;' : '∃', # exists ∃
    '&empty;' : '∅', # empty ∅
    '&nabla;' : '∇', # nabla ∇
    '&isin;'  : '∈', # isin ∈
    '&notin;' : '∉', # notin ∉
    '&ni;'    : '∋', # ni ∋
    '&prod;'  : '∏', # prod ∏
    '&sum;'   : '∑', # sum ∑
    '&minus;' : '−', # minus −
    '&lowast;': '∗', # lowast ∗
    '&radic;' : '√', # square root √
    '&prop;'  : '∝', # proportional to ∝
    '&infin;' : '∞', # infinity ∞
    '&ang;'   : '∠', # angle ∠
    '&and;'   : '∧', # and ∧
    '&or;'    : 'v', # or ∨ -> changed for latin v
    '∨'       : 'v', # or ∨ -> changed for latin v
    '&cap;'   : '∩', # cap ∩
    '&cup;'   : '∪', # cup ∪
    '&int;'   : '∫', # integral ∫
    '&there4;': '∴', # therefore ∴
    '&sim;'   : '∼', # similar to ∼
    '&cong;'  : '≅', # congruent to ≅
    '&asymp;' : '≈', # almost equal ≈
    '&ne;'    : '≠', # not equal ≠
    '&equiv;' : '≡', # equivalent ≡
    '&le;'    : '≤', # less or equal ≤
    '&ge;'    : '≥', # greater or equal ≥
    '&sub;'   : '⊂', # subset of ⊂
    '&sup;'   : '⊃', # superset of ⊃
    '&nsub;'  : '⊄', # not subset of ⊄
    '&sube;'  : '⊆', # subset or equal ⊆
    '&supe;'  : '⊇', # superset or equal ⊇
    '&oplus;' : '⊕', # circled plus ⊕
    '&otimes;': '⊗', # circled times ⊗
    '&perp;'  : '⊥', # perpendicular ⊥
    '&sdot;'  : '⋅', # dot operator ⋅





    '&OElig;'  : 'Œ',  # capital ligature OE	Œ
    '&oelig;'  : 'œ',  # small ligature oe	œ
    '&Scaron;' : 'Š',  # capital S with caron	Š
    '&scaron;' : 'š',  # small S with caron	š
    '&fnof;'   : 'f',  # f with hook	ƒ -> Changed to latin f
    'f'        : 'f',  # f with hook    ƒ -> Changed to latin f
    '&circ;'   : '',   # modifier letter circumflex accent	ˆ
    '&tilde;'  : '',   # small tilde	˜
    '&ensp;'   : ' ',  # en space	 
    '&emsp;'   : ' ',  # em space	 
    '&thinsp;' : ' ',  # thin space	 
    '&zwnj;'   : '',   # zero width non-joiner	‌
    '&zwj;'    : '',   # zero width joiner	‍
    '&lrm;'    : '',   # left-to-right mark	‎
    '&rlm;'    : '',   # right-to-left mark	‏
    '&ndash;'  : '-',  # en dash	–
    '&mdash;'  : '-',  # em dash	—
    '&lsquo;'  : "'",  # left single quotation mark	‘
    '&rsquo;'  : "'",  # right single quotation mark	’
    '&sbquo;'  : ',',  # single low-9 quotation mark	‚
    '&ldquo;'  : '"',  # left double quotation mark	“
    '&rdquo;'  : '"',  # right double quotation mark	”
    '&bdquo;'  : '"',  # double low-9 quotation mark	„
    '&dagger;' : '',   # dagger	†
    '&Dagger;' : '',   # double dagger	‡
    '&bull;'   : '',   # bullet	•
    '&hellip;' : '...', # horizontal ellipsis	…
    '&permil;' : '‰',  # per mille 	‰
    '&prime;'  : "'",  # minutes	′
    '&Prime;'  : "''", # seconds	″
    '&lsaquo;' : '<',  # single left angle quotation	‹
    '&rsaquo;' : '>',  # single right angle quotation	›
    '&oline;'  : '-',  # overline	‾
    '&trade;'  : '',   # trademark	™
    '&larr;'   : '<-', # left arrow	←
    '&uarr;'   : '',   # up arrow	↑
    '&rarr;'   : '->', # right arrow	→
    '&darr;'   : '',   # down arrow	↓
    '&harr;'   : '',   # left right arrow	↔
    '&crarr;'  : '<-', # carriage return arrow	↵
    '&lceil;'  : '',   # left ceiling	⌈
    '&rceil;'  : '',   # right ceiling	⌉
    '&lfloor;' : '',   # left floor	⌊
    '&rfloor;' : '',   # right floor	⌋
    '&loz;'    : '',   # lozenge	◊
    '&spades;' : '',   # spade	♠
    '&clubs;'  : '',   # club	♣
    '&hearts;' : '',   # heart	♥
    '&diams;'  : '',   # diamond	♦

   # '\xef\x80\xa0': '',
   # '\xef\x80\xb4': '',      # private use 
   # '\xef\x82\x9f': '',      # private use 
   # '\xef\x80\xb4': '',      # private use 
   # '\xef\x80\x8c': '',      # private use 
   # '\xef\x81\xa1': '',      # private use 
   # '\xef\x81\xb6': '',      # private use 
   # '\xef\x82\xb7': '',      # private use 
   # '\xef\x83\xa0': '',      # private use 
   # '\xef\x83\xa8': '',      # private use 
   # '\xef\x83\xbc': '',      # private use 
   # '\xef\x83\xb0': '',      # private use 
   # '\xef\xbf\xbd': ''       # replacement character �

   #New additions
  '\xE2\x80\x8B'   : '', # Empty blank character
  '\xE1\xAD\xA1'   : '', # BALINESE MUSICAL SYMBOL DONG ᭡
  '\xE2\x81\xAE'   : '', # National digit shapes (not printable)
  '\xE2\x95\xAC'   : '', # ╬
  #Arabic characters
  '\xE2\xB8\xAE'   : '?', # ؟ -> ?
  '&#1567'         : '?', # ؟ -> ?
  '\xD8\x9F'       : '?', # ؟ -> ?
  '&#11822'        : '?', # ؟ -> ?
  #L: 13/01/2016 https://trello.com/c/2ptAa1tY/234-0-jc-modify-normalize-chars-to-add-new-quotes
  #All single quotes
  #'\xCA\xB9'       : "'", # ʹ -> '
  #'\xCA\xBB'       : "'", # ʻ -> '
  #'\xCA\xBC'       : "'", # ʼ -> '
  #'\xCA\xBD'       : "'", # ʽ -> '
  #'\xCA\xBE'       : "'", # ʾ -> '
  #'\xCA\xBF'       : "'", # ʿ -> '
  #Other changes
  '\xCB\x80'       : "?", # ˀ -> ¿
  '\xCB\x81'       : "¿", # ˁ -> ?
  '\xCB\x82'       : "<", # ˂ -> <
  '\xCB\x83'       : ">",  # ˃ -> >
  '\xE2\x99\xAA'   : "" # ♪ ->  (removed) #JC: 29/07/2016

}



def replace_chars(match):
  char = match.group(0)
  return chars[char]


def replace_chars3(match):
  char = match.group(0)

  return ""



def main():

  input = sys.stdin
  output = sys.stdout
  filestats = ""
  file_name = ""
  lang = ""

  # Parse options
  try:
    opts, args = getopt.getopt(sys.argv[1:], "s:hl:", ["stats=","lang=","language=","help"])
  except getopt.GetoptError, err:
    help()
    sys.exit(2)

  for o, v in opts:
    if o in ("-h", "--help"):
      help()
      sys.exit(0)
    elif o in ("-s", "--stats"):
      filestats=v
    elif o in ("-l", "--lang", "--language"):
      lang=v

  # Parse params
  if not (len(args) in [0,1,2]):
    help()
    sys.exit(2)

  # Loading output file
  try:
    if len(args) == 2:
      output = open(args[1], "w")
  except IOError:
    sys.stderr.write("Error: File '{0}' cannot be created.\n".format(args[1]))
    sys.exit(3)

  try:
    if len(args) in [1,2]:
      input = open(args[0], "r")
      file_name = args[0]
  except IOError:
    sys.stderr.write("Error: File '{0}' cannot be opened.\n".format(args[0]))
    sys.exit(3)

  try:
    if filestats != "":
      filestats = open(filestats, "w")
  except IOError:
    sys.stderr.write("Error: File '{0}' cannot be created.\n".format(filestats))
    sys.exit(3)


  count_matches = 0


  #Remove and/or replace certain keys from 'chars' in German
  if lang in ["de","DE"]:
    chars['&bdquo;'] = '„'
    chars['\xe2\x80\x9e'] = '„'
    chars['\xc3\x98'] = 'Ø'         # latin capital letter o with stroke Ø
    chars['\xc3\xb8'] = 'ø'         # latin small letter o with stroke ø
    chars['&Oslash;'] = 'Ø'    # Ø
    chars['&oslash;'] = 'ø'
  elif lang in ["ar","AR"]:
    chars['\xE2\xB8\xAE'] = '؟' #Restore the reversed question marks and unify them
    chars['\xD8\x9F'] = '؟'
    chars['&#1567'] = '؟'
    chars['&#11822'] = '؟'
  elif lang in ["he","HE"]:
    chars['׳']='׳'
    chars['״']='״'
    chars['־']='־'
    chars['׀']='׀'
    chars['׃']='׃'
  else:
    chars['׳']="'"
    chars['״']='"'
    chars['־']='-'
    chars['׀']='|'
    chars['׃']=':'
  if lang not in ["ru","RU"]:
    # Cyrilic charcaters replaced to latin characters
    chars['Ѐ'] = 'È'
    chars['Ё'] = 'Ë'
    chars['Ѕ'] = 'S'
    chars['Ї'] = 'Ï'
    chars['І'] = 'I'
    chars['Ј'] = 'J'
    chars['А'] = 'A'
    chars['В'] = 'B'
    chars['Е'] = 'E'
    chars['К'] = 'K'
    chars['М'] = 'M'
    chars['Н'] = 'H'
    chars['О'] = 'O'
    chars['Р'] = 'P'
    chars['С'] = 'C'
    chars['Т'] = 'T'
    chars['У'] = 'y'
    chars['Х'] = 'X'
    chars['Ь'] = 'b'
    chars['ѐ'] = 'è'
    chars['ё'] = 'ë'
    chars['а'] = 'a'
    chars['в'] = 'B'
    chars['г'] = 'r'
    chars['е'] = 'e'
    chars['к'] = 'k'
    chars['м'] = 'M'
    chars['н'] = 'H'
    chars['о'] = 'o'
    chars['р'] = 'p'
    chars['с'] = 'c'
    chars['т'] = 'T'
    chars['у'] = 'y'
    chars['х'] = 'x'
    chars['ь'] = 'b'
    chars['ѕ'] = 's'
    chars['і'] = 'i'
    chars['ї'] = 'ï'
    chars['ј'] = 'j'
    chars['Ү'] = 'Y'
    chars['Һ'] = 'h'
    chars['һ'] = 'h'
    chars['Ӏ'] = 'I'
    chars['ӏ'] = 'I'
    chars['Ӓ'] = 'Ä'
    chars['ӓ'] = 'ä'
    chars['Ԁ'] = 'd'
    chars['ԁ'] = 'd'
    chars['Ԛ'] = 'Q'
    chars['ԛ'] = 'q'
    chars['Ԝ'] = 'W'
    chars['ԝ'] = 'w'
    chars['Ꙇ'] = 'l'
    chars['ꙇ'] = 'l'
    chars['Ꚃ'] = 'S'
    chars['ꚃ'] = 'S'
    chars['\xd1\x83']='y' #
  if lang not in ["el","EL"]:
    #TODO: WARNING if we add Greek, we must normalize html entities anyway
    # Greek Letters
    chars['&Alpha;'] ='A' # Alpha	Α -> Changed to latin A
    chars['Α'] ='A' # Alpha  Α -> Changed to latin A
    chars['&Beta;'] ='B' # Beta	Β -> Changed to latin B
    chars['Β'] ='B' # Beta   Β -> Changed to latin B
    chars['&Gamma;'] ='Γ' # Gamma	Γ
    chars['&Delta;'] ='Δ' # Delta	Δ
    chars['&Epsilon;'] ='E' # Epsilon	Ε -> Changed to latin E
    chars['Ε'] ='E' # Epsilon        Ε -> Changed to latin E
    chars['&Zeta;'] ='Z' # Zeta	Ζ -> Changed to latin Z
    chars['Ζ'] ='Z' # Zeta   Ζ -> Changed to latin Z
    chars['&Eta;'] ='H' # Eta	Η -> Changed to latin H
    chars['Η'] ='H' # Eta    Η -> Changed to latin H
    chars['&Theta;'] ='Θ' # Theta	Θ
    chars['&Iota;'] ='I' # Iota	Ι -> Chaged to latin I
    chars['Ι'] ='I' # Iota   Ι -> Chaged to latin I
    chars['&Kappa;'] ='K' # Kappa	Κ -> Changed to latin K
    chars['Κ'] ='K' # Kappa  Κ -> Changed to latin K
    chars['&Lambda;'] ='Λ' # Lambda	Λ
    chars['&Mu;'] ='M' # Mu	Μ -> Changed to latin M
    chars['Μ'] ='M' # Mu     Μ -> Changed to latin M
    chars['&Nu;'] ='N' # Nu	Ν -> Changed to latin N
    chars['Ν'] ='N' # Nu     Ν -> Changed to latin N
    chars['&Xi;'] ='Ξ' # Xi	Ξ
    chars['&Omicron;'] ='O' # Omicron	Ο -> Changed to latin O
    chars['Ο'] ='O' # Omicron        Ο -> Changed to latin O
    chars['&Pi;'] ='Π' # Pi	Π
    chars['&Rho;'] ='P' # Rho	Ρ -> Changed to latin P
    chars['Ρ'] ='P' # Rho    Ρ -> Changed to latin P
    chars['&Sigma;'] ='Σ' # Sigma	Σ
    chars['&Tau;'] ='T' # Tau	Τ -> Changed to latin T
    chars['Τ'] ='T' # Tau    Τ -> Changed to latin T
    chars['&Upsilon;'] ='Y' # Upsilon	Υ -> Changed to latin Y
    chars['Υ'] ='Y' # Upsilon        Υ -> Changed to latin Y
    chars['&Phi;'] ='Φ' # Phi	Φ
    chars['&Chi;'] ='X' # Chi	Χ -> Changed to latin X
    chars['Χ'] ='X' # Chi    Χ -> Changed to latin X
    chars['&Psi;'] ='Ψ' # Psi	Ψ
    chars['&Omega;'] ='Ω' # Omega	Ω
    chars['&alpha;'] ='a' # alpha	α -> Changed to latin a
    chars['α'] ='a' # alpha  α -> Changed to latin a
    chars['&beta;'] ='β' # beta	β
    chars['&gamma;'] ='γ' # gamma	γ
    chars['&delta;'] ='δ' # delta	δ
    chars['&epsilon;'] ='ε' # epsilon	ε
    chars['&zeta;'] ='ζ' # zeta	ζ
    chars['&eta;'] ='n' # eta	η -> Changed to latin n
    chars['η'] ='n' # eta    η -> Changed to latin n
    chars['&theta;'] ='θ' # theta	θ
    chars['&iota;'] ='ι' # iota	ι
    chars['&kappa;'] ='k' # kappa	κ -> Changed to latin k
    chars['κ'] ='k' # kappa  κ -> Changed to latin k
    chars['&lambda;'] ='λ' # lambda	λ
    chars['&mu;'] ='μ' # mu	μ
    chars['&nu;'] ='v' # nu	ν -> Changed to latin v
    chars['ν'] ='v' # nu     ν -> Changed to latin v
    chars['&xi;'] ='ξ' # xi	ξ
    chars['&omicron;'] ='o' # omicron	ο -> Changed to latin o
    chars['ο'] ='o' # omicron        ο -> Changed to latin o
    chars['&pi;'] ='π' # pi	π
    chars['&rho;'] ='p' # rho	ρ -> Changed to latin p
    chars['ρ'] ='p' # rho    ρ -> Changed to latin p
    chars['&sigmaf;'] ='ς' # sigmaf	ς
    chars['&sigma;'] ='σ' # sigma	σ
    chars['&tau;'] ='t' # tau	τ -> Changed to latin t
    chars['τ'] ='t' # tau    τ -> Changed to latin t
    chars['&upsilon;'] ='u' # upsilon	υ -> Changed to latin u
    chars['υ'] ='u' # upsilon        υ -> Changed to latin u
    chars['&phi;'] ='φ' # phi	φ
    chars['&chi;'] ='χ' # chi	χ
    chars['&psi;'] ='ψ' # psi	ψ
    chars['&omega;'] ='ω' # omega	ω
    chars['&thetasym;'] ='ϑ' # theta symbol	ϑ
    chars['&upsih;'] ='ϒ' # upsilon symbol	ϒ
    chars['&piv;'] ='ϖ' # pi symbol	ϖ
    chars['\xCE\xBF']='o' #GREEK SMALL LETTER OMICRON

  #L: 19/06/2017: Moved condition of Japanese space out of language condition to convert all Japanese spaces into latin spaces to avoid problems with classic filters. At the end of the automatic cleaning step of corpora, we replace back the Japanese spaces in Japanese language (if appliable)
  chars['\xE3\x80\x80'] = ' ' #　-Japanse space

  #JC: 29/07/2016
  if lang not in ["ja","JA"]:
    # We must normalize special punctuation marks to avoid that an en-ja pair the English part contains Japanese punctuation marks
    chars['\xEF\xBD\x9B'] = '{' #｛
    chars['\xEF\xBD\x9D'] = '}' #｝
    chars['\xEF\xBC\x88'] = '(' #（
    chars['\xEF\xBC\x89'] = ')' #）
    chars['\xEF\xBC\xBB'] = '[' #［
    chars['\xEF\xBC\xBD'] = ']' #］
    chars['\xE3\x80\x90'] = '(' # 【 - Personal JC decission
    chars['\xE3\x80\x91'] = ')' # 】 - Personal JC decission
    chars['\xE3\x80\x82'] = '.' #。
    chars['\xE3\x80\x81'] = ',' #、
    chars['\xEF\xBC\x8C'] = ',' #，
    chars['\xE2\x80\xA6'] = '...' #…
    chars['\xE2\x80\xA5'] = '...' #‥
#    chars['\xE3\x80\x80'] = ' ' #　-Japanse space
    chars['\xEF\xBC\x9A'] = ':' #：
    chars['\xEF\xBC\x9B'] = ';' #；
    chars['\xEF\xBC\x9F'] = '?' #？
    chars['\xEF\xBC\x81'] = '!' #！
    chars['\xEF\xBC\x9C'] = '<' #＜
    chars['\xEF\xBC\x9D'] = '=' #＝
    chars['\xEF\xBC\x9E'] = '>' #＞
    chars['\xEF\xBC\xBF'] = '_' #＿
    chars['\xEF\xBD\x80'] = "'" #｀
  else:
    chars['{'] = '\xEF\xBD\x9B' #｛
    chars['}'] = '\xEF\xBD\x9D' #｝
    chars['('] = '\xEF\xBC\x88' #（
    chars[')'] = '\xEF\xBC\x89' #）
    chars['['] = '\xEF\xBC\xBB' #［
    chars[']'] = '\xEF\xBC\xBD' #］
    chars['\xE3\x80\x90'] = '\xE3\x80\x90' # 【 - Personal JC decission #We maintain the same char
    chars['\xE3\x80\x91'] = '\xE3\x80\x91' # 】 - Personal JC decission #We maintain the same char
    chars['\xE3\x80\x82'] = '\xE3\x80\x82' #。 #We maintain the same char
    chars[','] = '\xE3\x80\x81' #、
    chars[','] = '\xEF\xBC\x8C' #，
    chars['\xE2\x80\xA6'] = '\xE2\x80\xA6' #… #We maintain the same char
    chars['\xE2\x80\xA5'] = '\xE2\x80\xA5' #‥ #We maintain the same char
#    chars[' '] = '\xE3\x80\x80' #　-Japanse space
    chars[':'] = '\xEF\xBC\x9A' #：
    chars[';'] = '\xEF\xBC\x9B' #；
    chars['?'] = '\xEF\xBC\x9F' #？
    chars['!'] = '\xEF\xBC\x81' #！
    chars['<'] = '\xEF\xBC\x9C' #＜
    chars['='] = '\xEF\xBC\x9D' #＝
    chars['>'] = '\xEF\xBC\x9E' #＞
    chars['_'] = '\xEF\xBC\xBF' #＿
    chars["'"] = '\xEF\xBD\x80' #｀


  #Compile regular expressions only once

  #Replace all html entities
  htmlEntity=regex.compile(ur'[&][[:space:]]*[#][[:space:]]*[0-9]{2,4}[[:space:]]*[;]?',regex.U)
  allControlCharsRe=re.compile("[\x00-\x09\x0B-\x1F]")
  charsRe=re.compile("(\\" + '|\\'.join(chars.keys()) + ")")
  chars3Re=re.compile("\xee\x80[\x80-\xff]|\xee[\x81-\xff][\x00-\xff]|\xef[\x00-\xbe][\x00-\xff]|\xef\xbf[\x00-\xe7]")
  chars3Re2=re.compile("\xe2\x80[\x80-\x8f]")
  chars3Re3=re.compile("\x7f|\xc2[\x80-\xa0]")
  quotesRegex=regex.compile("(?P<start>[[:alpha:]])\'\'(?P<end>(s|S|t|T|m|M|d|D|re|RE|ll|LL|ve|VE|em|EM)\W)")

  for i in input:

    i=i.rstrip("\n")

    #First replacing all HTML entities
    for substring in regex.findall(htmlEntity,i):
      code=substring.replace(' ','')[2:].replace(';','')
      newChar=unichr(int(code)).encode("utf8")
      if newChar != u"\n":
        i=i.replace(substring,newChar)

    #JC: 12/06/2015. First remove ALL control chars
    i = allControlCharsRe.sub("", i)

#    print "Replacing using chars {}".format(i)
    i = charsRe.sub(replace_chars, i)

    #JC: 29/07/2016: Not applicable if lang is JAPANESE
    if lang not in ["ja","JA"]:
#      print "Replacing using special list {}".format(i)
      #from \xee\x80\x80 to \xef\xbf\xe7
      i = chars3Re.sub(replace_chars3, i)

    i = chars3Re2.sub(replace_chars3, i)

    i = chars3Re3.sub(replace_chars3, i)

    i = quotesRegex.sub( "\g<start>\'\g<end>", i)

    output.write("{0}\n".format(i))


if __name__ == "__main__":
  main()
