" $Id: xcat.vim,v 1.1 2012/08/23 20:35:00 syahn Exp $
" Vim syntax file
" Language:	xcat for SBPlatform3 syslog file
" Maintainer:	Ahn, Soyeon <syahn@solbox.com>
" Last Change:	$Date: 2012/08/23 20:35:00 $
" Remark: Add some color to log files produced by xcat syslogd.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Error log
syn match   xcatError       / \d\+:\d\+\>.*ERROR.*$/ contained
" Client Connection log
syn match   xcatClientCmd   / \d\+:\d\+\>.*Allowing.*$/ contained
" Run command log
syn match   xcatRunCmd   / \d\+:\d\+\>.*runCloudCommand command.*$/ contained
" DB command log
syn match   xcatDB      /QUERY='.*'$/ contained
" Normal log
syn match	xcatText	    /.*$/                contains=xcatError,xcatClientCmd,xcatRunCmd,xcatDB

syn match	xcatFacility    /.\{-1,}:/	         nextgroup=xcatText skipwhite
syn match	xcatHost	    /\S\+/	             nextgroup=xcatFacility,xcatText skipwhite
syn match	xcatDate	    /^.\{-}\d\d:\d\d:\d\d/	nextgroup=xcatHost skipwhite

if !exists("did_xcat_syntax_inits")
  let did_xcat_syntax_inits = 1
  hi link xcatDate 	        Comment
  hi link xcatHost	        Type
  hi link xcatFacility	    Statement
  hi link xcatDB 	        Debug
  hi link xcatError         Error
  hi link xcatClientCmd		Identifier 
  hi link xcatRunCmd		String 
endif

let b:current_syntax="xcat"
