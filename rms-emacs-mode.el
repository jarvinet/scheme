; http://two-wugs.net/emacs/mode-tutorial.html
;An Emacs language mode creation tutorialAn Emacs language mode creation tutorial
;Introduction
;I've written several Emacs modes for various obscure or in-house tool languages. 
;When starting my first mode, I found that there weren't a lot of lucid 
;explanations of how to write a mode intended for language editing. Even Writing 
;GNU Emacs Extensions doesn't cover topics like syntax highlighting and 
;indentation. And generic-mode, distributed with recent versions of Emacs, 
;doesn't handle indentation. 
;Here, I walk through my wpdl-mode.el, a mode for editing Workflow Process 
;Definition Language files. I simply go through each line of the mode, and 
;explain what it does. It may also be helpful to refer to this WPDL example, to 
;see how the concepts are being applied. Hopefully wpdl-mode is clear and simple 
;enough for you to learn the basics of writing your own mode. 
;The following topics are covered: 
;  Basic mode setup 
;  Syntax highlighting 
;  Indentation 
;  Syntax table modifications 
;  The entry function 
;  Style suggestions 
;The following information was written with GNU Emacs versions 20 or 21 in mind. 
;NB: Since I am not a professional Emacs hacker, some of this might be a case of 
;the blind leading the blind. More experienced Emacs guys may take offense at the 
;style or terminology, and will hopefully correct my ignorance. Thanks to readers 
;on comp.emacs and gnu.emacs.help who have already contributed suggestions! 
;Copyright © 2002 Scott Andrew Borton 
;The mode
;Setup

;(defvar wpdl-mode-hook nil)
;(defvar wpdl-mode-map nil
;  "Keymap for WPDL major mode")

(defvar rms-mode-hook nil)
(defvar rms-mode-map nil
  "Keymap for rms major mode")

;Here, we define some variables that all modes should define. wpdl-mode-hook 
;allows the user to run their own code when your mode is run. wpdl-mode-map 
;allows users to define their own keymaps. 

;(if wpdl-mode-map nil
;  (setq wpdl-mode-map (make-keymap)))

(if rms-mode-map nil
  (setq rms-mode-map (make-keymap)))

;Now we're assigining a default keymap, if the user hasn't already defined one. 

;(setq auto-mode-alist
;	  (append
;	   '(("\\.wpd\\'" . wpdl-mode))
;	   auto-mode-alist))

(setq auto-mode-alist
      (append
       '(("\\.rms\\'" . rms-mode))
       auto-mode-alist))

;Here, we append a definition to auto-mode-alist. This tells emacs that when a 
;buffer with a name ending with .wpd is opened, then wpdl-mode should be started 
;in that buffer. Some modes leave this step to the user. 
;Syntax highlighting using keywords

;(defconst wpdl-font-lock-keywords-1
;  (list
;   '("\\<\\(A\\(CTIVITY\\|PPLICATION\\)\\|DATA\\|END_\\(A\\(CTIVITY\\|PPLICATION\\)\\|DATA\\|MODEL\\|PARTICIPANT\\|T\\(OOL_LIST\\|RANSITION\\)\\|WORKFLOW\\)\\|MODEL\\|PARTICIPANT\\|T\\(OOL_LIST\\|RANSITION\\)\\|WORKFLOW\\)\\>" . font-lock-builtin-face)
;   '("\\('\\w*'\\)" . font-lock-variable-name-face))
;  "Minimal highlighting expressions for WPDL mode")

; rms operation names
(defconst rms-font-lock-keywords-1
  (list
   '("\\<\\(assign\\|branch\\|goto\\|perform\\|restore\\|save\\|test\\)\\>" . font-lock-variable-name-face))
  "Minimal highlighting expressions for rms mode")

;   '("\\<\\(?:assign\\|branch\\|goto\\|perform\\|restore\\|save\\|test\\)\\>" . font-lock-string-face))

;Now we have defined our minimal set of keywords for emacs to highlight. A 
;font-lock-keyword variable is a list of keywords to highlight. There are many 
;ways to specify this list. I have used the form (matcher . facename). With this 
;form, I have specified a pattern to match, and then a face name to use for the 
;actual highlighting. 
;There are two elements to my list: the first element matches WPDL language 
;keywords, and the second element matches WPDL identifier names (variable names). 
;I have selected the appropriate font-lock face names for each type of keyword 
;(font-lock-builtin-face and font-lock-variable-name-face, respectively). 
;For my keyword list, I've selected those WPDL keywords which would benefit most 
;from being highlighted: keywords that delimit blocks of information. One may 
;notice that the regexp used to specify these keywords is optimized. I did not 
;have to do this by hand. Emacs provides the regexp-opt function to save you from 
;the tedious work of creating complicated regexps. regexp-opt takes a list of 
;strings and an additional optional argument. This optional argument controls 
;whether or not we want to wrap the entire regexp in parens. In our case, we do. 
;For example, the following expression: 
;(regexp-opt '("PARTICIPANT" "END_PARTICIPANT" "MODEL" "END_MODEL" "WORKFLOW" 
;"END_WORKFLOW" "ACTIVITY" "END_ACTIVITY" "TRANSITION" "END_TRANSITION" 
;"APPLICATION" "END_APPLICATION" "DATA" "END_DATA" "TOOL_LIST" "END_TOOL_LIST") 
;t) 
;Results in this regexp: 
;"\\(A\\(CTIVITY\\|PPLICATION\\)\\|DATA\\|END_\\(A\\(CTIVITY\\|PPLICATION\\)\\|DATA\\|MODEL\\|PARTICIPANT\\|T\\(OOL_LIST\\|RANSITION\\)\\|WORKFLOW\\)\\|MODEL\\|PARTICIPANT\\|T\\(OOL_LIST\\|RANSITION\\)\\|WORKFLOW\\)" 

;Because font-lock is so resource-intensive, providing optimized regexps to 
;font-lock should provide a boost in performance. 
;Finally, the regexp is wrapped in \< and \>. These indicate that the regexp 
;should only match keywords if they are surrounded by either a space or a 
;beginning/end-of-file. This ensures that, for example, the keyword if is not 
;highlighted in the word difference. 

;(defconst wpdl-font-lock-keywords-2
;  (append wpdl-font-lock-keywords-1
;		  (list
;		   '("\\<\\(AUTHOR\\|C\\(ONDITION\\|REATED\\)\\|DE\\(FAULT_VALUE\\|SCRIPTION\\)\\|EXTENDED_ATTRIBUTE\\|FROM\\|I\\(MPLEMENTATION\\|N_PARAMETERS\\)\\|JOIN\\|NAME\\|O\\(THERWISE\\|UT_PARAMETERS\\)\\|PERFORMER\\|ROUTE\\|S\\(PLIT\\|TATUS\\)\\|T\\(O\\(OLNAME\\)?\\|YPE\\)\\|VENDOR\\|WPDL_VERSION\\)\\>" . font-lock-keyword-face)
;		   '("\\<\\(TRUE\\|FALSE\\)\\>" . font-lock-constant-face)))
;  "Additional Keywords to highlight in WPDL mode")

; rms additional keywords
(defconst rms-font-lock-keywords-2
  (append rms-font-lock-keywords-1
	  (list
	   '("\\<\\(const\\|label\\|op\\|reg\\)\\>" . font-lock-reference-face)))
  "Additional Keywords to highlight in rms mode")

;	   '("\\(?:const\\|label\\|op\\|reg\\)" . font-lock-string-face)))

;Now I've defined the second level of highlighting. Note that the second level is 
;appended to the first level, resulting in a single keyword variable that matches 
;everything in both levels. Here I've specified even more keywords, along with 
;two common WPDL constant values, TRUE and FALSE. 

;(defconst wpdl-font-lock-keywords-3
;  (append wpdl-font-lock-keywords-2
;		  (list
;		   '("\\<\\(A\\(ND\\|PPLICATIONS\\)\\|BOOLEAN\\|HUMAN\\|INTEGER\\|NO\\|OR\\(GANISATIONAL_UNIT\\)?\\|R\\(EFERENCE\\|OLE\\)\\|S\\(TRING\\|YNCHR\\)\\|UNDER_REVISION\\|WORKFLOW\\|XOR\\)\\>" . font-lock-constant-face)))
;  "Balls-out highlighting in WPDL mode")

; rms register names
(defconst rms-font-lock-keywords-3
  (append rms-font-lock-keywords-2
	  (list
	   '("\\<\\(argl\\|continue\\|e\\(?:nv\\|xp\\)\\|init\\|proc\\|unev\\|val\\)\\>" . font-lock-preprocessor-face)))
  "Balls-out highlighting in rms mode")

;	   '("\\(?:argl\\|continue\\|e\\(?:nv\\|xp\\)\\|init\\|proc\\|unev\\|val\\)" . font-lock-string-face)))

;I've now defined more WPDL constants. This completes the list of WPDL keywords. 

;(defvar wpdl-font-lock-keywords wpdl-font-lock-keywords-3
;  "Default highlighting expressions for WPDL mode")

(defvar rms-font-lock-keywords rms-font-lock-keywords-3
  "Default highlighting expressions for rms mode")

;Here I've defined the default level of highlighting to be the maximum. This is 
;just my preference- the user can change this variable (if the user knows how! 
;This might be something to put in the documentation for your own mode). 


;Indentation
;WPDL features a Pascal-like syntax. This provides a natural basis for 
;indentation. Blocks of information can be indented away from their parent. 
;Fortunately, this doesn't seem to be too difficult to accomplish with Emacs- the 
;indentation code for wpdl-mode is only 28 lines long. Here is some example WPDL 
;code, including indentation: 
;
;WORKFLOW	'In_the_Mail_Room'
;    CREATED	1998-07-15
;    NAME	"In the Mail Room"
;
;    ACTIVITY	'MailRoom'
;        NAME	"Mail Room"
;        TOOL_LIST 
;            'scan_document'
;            'identify_document'
;            'send_document'
;        END_TOOL_LIST
;        PERFORMER 'Joe'
;    END_ACTIVITY
;
;END_WORKFLOW
;
;I have identified five rules for indenting WPDL code. The rules are as follows: 
;  If we are at the beginning of the buffer, indent to column 0. 
;  If we are currently at an END_ line, then de-indent relative to the previous line. 
;  If we first see an END_ line before our current line, then we should indent 
;  our current line to the same indentation as the END_ line. 
;  If we first see a "start line" like PARTICIPANT, then we need to increase our 
;  indentation relative to that start line. 
;  If none of the above apply, then do not indent at all. 
;The following WPDL code example, with comments, may clarify these ideas: 
;
;// My activity              // Rule 1 applies
;ACTIVITY    'MailRoom'      // Rule 5 applies
;    NAME    "Mail Room"     // Rule 4 (based on "ACTIVITY")
;    TOOL_LIST               // Rule 4 (based on "ACTIVITY")
;        'scan_document'     // Rule 4 (based on "TOOL_LIST")
;        'identify_document' // Rule 4 (based on "TOOL_LIST")
;        'send_document'     // Rule 4 (based on "TOOL_LIST")
;    END_TOOL_LIST           // Rule 2
;    PERFORMER 'Joe'         // Rule 3
;END_ACTIVITY                // Rule 2

;(defun wpdl-indent-line ()
;  "Indent current line as WPDL code"
;  (interactive)
;  (beginning-of-line)

;We start by defining a single function for determining how a given line should 
;be indented. It may be helpful to make the function interactive, to aid you in 
;testing your indentation function. Making the function interactive allows you to 
;call the function directly using M-x your-function. Also, we set the point to 
;the beginning of the line. 

;(if (bobp)  ; Check for rule 1
;      (indent-line-to 0)

;The first indentation-related thing we do is to check to see if this is the 
;first line in the buffer, using the function bobp. If it is, we set the 
;indentation level to 0, using indent-line-to. indent-line-to indents the current 
;line to the given column. Please note that if this condition is true, then the 
;rest of the indentation code is not considered. 

;  (let ((not-indented t) cur-indent)

;Now we declare two variables. We will store the value of our intended 
;indentation level for this line in cur-indent. Then, when all of the indentation 
;options have been considered (rules 2-5), we will finally make the indentation. 
;The use of not-indented will become clear later. 

;        (if (looking-at "^[ \t]*END_") ; Check for rule 2
;            (progn
;              (save-excursion
;                (forward-line -1)
;                (setq cur-indent (- (current-indentation) default-tab-width)))

;If we are not at the beginning of the buffer, then we start to consider other 
;indentation options. What we do here is to check to see if we are at the end of 
;a block. In WPDL, blocks are ended by keywords that start with END_. So, we 
;check to see if we are on such a line by using the looking-at function, using a 
;regexp that will detect if we are at a line that starts with END_. Remember, we 
;are at the beginning of the line, so we need to include any spaces or tabs in 
;the regexp. 
;If we see that we are at the end of a block, we then set the indentation level. 
;We do this by going to the previous line (using the forward-line function), and 
;then use the current-indentation function to see how that line is indented. Then 
;we set cur-indent with the value of the previous line's indentation, minus the 
;default-tab-width. 

;              (if (< cur-indent 0)
;                  (setq cur-indent 0)))

;We also include a safety check, so that we don't try to indent past the left 
;margin. 

;        (save-excursion 
;          (while not-indented
;            (forward-line -1)
;            (if (looking-at "^[ \t]*END_") ; Check for rule 3
;                (progn
;                  (setq cur-indent (current-indentation))
;                  (setq not-indented nil))
;              ; Check for rule 4
;              (if (looking-at "^[ \t]*\\(PARTICIPANT\\|MODEL\\|APPLICATION\\|WORKFLOW\\|ACTIVITY\\|DATA\\|TOOL_LIST\\|TRANSITION\\)")
;                  (progn
;                    (setq cur-indent (+ (current-indentation) default-tab-width))
;                    (setq not-indented nil))
;                (if (bobp) ; Check for rule 5
;                    (setq not-indented nil)))))))

;If we are not looking at an END_ line, then we iterate backward through the code 
;to find an "indentation hint". An indentation hint is some token in our file 
;which can tell us how to indent the line we are on now . The rules I have 
;provided earlier tell us what the indentation hints are. At this point, we only 
;need to find the hints for rules 3-5, as the first two rules have already been 
;covered by previous code. 
;There aren't any new Emacs lisp functions introduced here. The only thing worth 
;noting is the use of not-indented as a sentinel value for our while loop. 

;      (if cur-indent
;          (indent-line-to cur-indent)
;        (indent-line-to 0))))) ; If we didn't see an indentation hint, then allow no indentation

;Finally, we execute the actual indentation, if we have actually identified an 
;indentation case. We have (most likely) already stored the value of the 
;indentation in cur-value. If cur-indent is empty, then we always indent to 
;column 0. 
;And that concludes the indentation code for WPDL. Exercise: This indentation 
;code is rather simple. In which cases would the code fail to create proper 
;indentation of WPDL code? 


(defun rms-indent-line ()
  "Indent current line as RMS code"
  (interactive)
  (beginning-of-line)
  (if (bobp)  ; Check for rule 1
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)
      (if (looking-at "^[ \t]*(") ; Check for rule 2
	  (setq cur-indent 2)
	(setq cur-indent 0))
      (if cur-indent
          (indent-line-to cur-indent)
        (indent-line-to 0))))) ; If we didn't see an indentation hint, then allow no indentation


;The syntax table
;Now we will set up a syntax table for WPDL. A syntax table tells Emacs how it 
;should treat various tokens in your text for various functions, including 
;movement within the buffer and syntax highlighting. For example, how does Emacs 
;know to move forward by one word (as used in the forward-word function)? The 
;syntax table gives Emacs this kind of information. The syntax table is also used 
;by the syntax highlighting package. It is for this reason that we want to modify 
;the syntax table for wpdl-mode. 

;(defvar wpdl-mode-syntax-table nil
;  "Syntax table for wpdl-mode.")

;We now define the variable that will hold the syntax table. 

;(defun wpdl-create-syntax-table ()
;  (if wpdl-mode-syntax-table
;      ()
;    (setq wpdl-mode-syntax-table (make-syntax-table))

;In this function, the first thing we do is check to see if 
;wpdl-mode-syntax-table is nil. If it is not, then we don't do anything else, 
;because the syntax table has already been created (which means that the mode has 
;been loaded before). 
;If the syntax table hasn't already been created, then we create it. We use the 
;make-syntax-table function to do this. This function creates a syntax table that 
;is a good start for most modes, as it either inherits or copies entries from the 
;standard syntax table. 

;    (modify-syntax-entry ?_ "w" wpdl-mode-syntax-table)

;The first modification we make to the syntax table is to declare the underscore 
;character '_' as being a valid part of a word. So now, a string like foo_bar 
;will be treated as one word rather than two (the default Emacs behavior). We do 
;this because we want to make it easier to treat WPDL variable names (which use 
;underscores by convention), and, more importantly, keywords, as single words. 
;NB: Treating underscores as non-whitespace is non-standard Emacs behavior. Here, 
;I feel justified in including this modification, since so many WPDL keywords 
;include underscores. 
;The modify-syntax-entry function takes a character as its first argument, a 
;syntax class as its second argument, and the syntax table to be modified as the 
;third argument. In Emacs Lisp, characters are represented by using the '?' 
;symbol followed by the actual character, so we use ?_ to represent the 
;underscore. The syntax class indicates how a particular character is treated. 
;Example syntax classes include "punctuation character," "open parenthesis 
;indicator", and "word constituent." 'w' is the symbol for "word constituent." 

;    (modify-syntax-entry ?/ ". 124b" wpdl-mode-syntax-table)
;    (modify-syntax-entry ?* ". 23" wpdl-mode-syntax-table)
;    (modify-syntax-entry ?\n "> b" wpdl-mode-syntax-table))

;WPDL comments are just like C++ comments. So, our goal is to program C++ 
;comments into the WPDL syntax table. To do this, we need to use some extra 
;syntax class parameters called syntax flags. Some syntax classes have these 
;extra parameters to further refine the place of the character within the 
;classes. The syntax class used here is '.', which means "punctuation character." 

;If we consult the Emacs lisp programming guide and see what the syntax flags 
;mean, we will see that we have made the following adjustments to the syntax 
;table: 
;1) That the character '/' is the start of a two-character comment sequence 
;('1'), that it may also be the second character of a two-character comment-start 
;sequence ('2'), that it is the end of a two-character comment-start sequence 
;('4'), and that comment sequences that have this character as the second 
;character in the sequence is a "b-style" comment ('b'). It's a rule that 
;comments that begin with a "b-style" sequence must end with either the same or 
;some other "b-style" sequence. 
;2) That the character '*' is the second character of a two-character 
;comment-start sequence ('2') and that it is the start of a two-character 
;comment-end sequence ('3'). 
;3) That the character '\n' (which is the newline character) ends a "b-style" 
;comment. 
;Now we have programmed our comment style into the syntax table. The syntax 
;highlighting mechanism (font-lock) will now read the syntax table and highlight 
;WPDL comments accordingly. 

;  (set-syntax-table wpdl-mode-syntax-table))

;Lastly, the syntax table is set as the syntax table for the buffer. 
;The entry function
;Finally, we will create the function that will be called by Emacs when the mode 
;is started. 

;(defun wpdl-mode ()
;  "Major mode for editing Workflow Process Description Language files"
;  (interactive)
;  (kill-all-local-variables)
;  (wpdl-create-syntax-table)



;Here we define our entry function, give it a documentation string, make it 
;interactive, and call our syntax table creation function. 

;  (make-local-variable 'font-lock-defaults)
;  (setq font-lock-defaults
;		'(wpdl-font-lock-keywords))

;Now we are specifying the font-lock (syntax highlighting) default keywords. Note 
;that if the user has specified her own level of keyword highlighting by 
;redefinine wpdl-font-lock-keywords, then that will be used instead of the 
;default. 

;  (make-local-variable 'indent-line-function)
;  (setq indent-line-function 'wpdl-indent-line)

;Here we register our line indentation function with Emacs. Now Emacs will call 
;our function every time line indentation is required (like when the user calls 
;indent-region). 

;  (setq major-mode 'wpdl-mode)
;  (setq mode-name "WPDL")
;  (run-hooks 'wpdl-mode-hook))

;The last steps in the entry function are to set the major-mode variable with the 
;value of our mode, to set the mode-name variable (which determines what name 
;will appear in the status line and buffers menu, for example), and to finally 
;call run-hooks so that the user's own mode hooks will be called. 

(defun rms-mode ()
  "Major mode for editing Register Machine Simulator Language files"
  (interactive)
  (kill-all-local-variables)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
		'(rms-font-lock-keywords))
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'rms-indent-line)
  (setq major-mode 'rms-mode)
  (setq mode-name "RMS")
  (run-hooks 'rms-mode-hook))


;The most important line

;(provide 'wpdl-mode)

(provide 'rms-mode)

;Finally, we use provide to expose our mode to the Emacs environment. Users will 
;most likely want to use the require function in the .emacs file to load the mode 
;into the environment. 
;A word about style
;The Emacs lisp manual has a section about style, including this part about major 
;mode style. In addition to following these guidelines, you may want to use the 
;checkdoc tool to help you get your style issues under control, especially 
;concerning the format of the initial comment block. 
;Acknowledgements
;Thanks to... 
;  Colin Marquardt for suggesting the use of defcustom and the note about style, 
;  especially checkdoc 
;  Alan Mackenzie for pointing out my original mistake of creating too many 
;  syntax tables 
;  Matt, Cyril, and others for making suggestions or asking pertinent questions 


;Make or see comments on this page
;Last modified: Wed May 14 16:44:35 FLE Daylight Time 2003 
;Scott Andrew Borton
;@two-wugs 

