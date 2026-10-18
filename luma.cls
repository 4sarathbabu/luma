% Reusable visual style and helpers. Put talk-specific choices in presentation.tex.
% Color palette, teaching blocks, highlights, figures, footer, and progress live here.
%% -- CLASS OPTIONS AND DEFAULT SLIDE SIZE -- %%

% Defaults: 16:9 slides and 11pt body text. Document-class options override these.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{luma}[2026/10/17 Luma presentation slides]

% Forward options such as handout, aspectratio=43, and 12pt to Beamer.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass[aspectratio=169,11pt]{beamer}

%% -- PACKAGES -- %%

% Latin Modern fonts, professional tables, and full-reference footnote citations.
% BibTeX is intentional: use the Makefile to run the bibliography passes.
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage{booktabs}
\RequirePackage[backend=bibtex,style=authoryear,giveninits=true,uniquename=init,maxbibnames=3]{biblatex}

%% -- GLOBAL LAYOUT AND SLIDE METRICS -- %%

% Main text margins are 9mm. Navigation icons and the top header are hidden.
\usetheme{default}
\usefonttheme{professionalfonts}
\setbeamersize{text margin left=9mm,text margin right=9mm}
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{headline}{}
\setbeamertemplate{itemize items}[circle]
\setbeamertemplate{blocks}[default]
\setbeamertemplate{caption}[numbered]

%% -- COLOR PALETTE -- %%

\definecolor{Navy}{HTML}{17324D}
\definecolor{Accent}{HTML}{007F82}
\definecolor{Text}{HTML}{243240}
\definecolor{Muted}{HTML}{64748B}

% Complementary palette: dark colors for text/lines, Light colors for backgrounds.
% Keep Text (the default text color) on pale highlight backgrounds.
\definecolor{Teal}{HTML}{006D70}
\definecolor{TealLight}{HTML}{E3F2F0}
\definecolor{Blue}{HTML}{315D85}
\definecolor{BlueLight}{HTML}{E8EFF7}
\definecolor{Amber}{HTML}{8A5A16}
\definecolor{AmberLight}{HTML}{FFF1D6}
\definecolor{Rose}{HTML}{A04450}
\definecolor{RoseLight}{HTML}{F8E8EB}
\definecolor{Purple}{HTML}{6B5486}
\definecolor{PurpleLight}{HTML}{EFEAF5}
\definecolor{GrayLight}{HTML}{EEF1F4}
% Examples:
% \highlight[AmberLight]{Key assumption}
% \textcolor{Blue}{Emphasized text}
% \highlight[Teal!15]{Custom tint}

%% -- TYPOGRAPHY -- %%

% Font sizes are centralized here: titles, block headings, footer, and citations.
% Footnote descriptions intentionally use tiny text.
\setbeamerfont{title}{size=\LARGE,series=\bfseries}
\setbeamerfont{subtitle}{size=\large}
\setbeamerfont{frametitle}{size=\Large,series=\bfseries}
\setbeamerfont{block title}{series=\bfseries}
\setbeamerfont{block title example}{series=\bfseries}
\setbeamerfont{block title alerted}{series=\bfseries}
\setbeamerfont{footline}{size=\scriptsize}
\setbeamerfont{footnote}{size=\tiny}

%% -- BASE SLIDE COLORS -- %%

% Override these colors in the presentation preamble to customize the theme.
\setbeamercolor{normal text}{fg=Text,bg=white}
\setbeamercolor{structure}{fg=Navy}
\setbeamercolor{alerted text}{fg=Accent}
\setbeamercolor{title}{fg=Navy}
\setbeamercolor{frametitle}{fg=Navy,bg=white}

%% -- TEACHING BLOCKS -- %%

\setbeamercolor{block title}{fg=Navy,bg=Navy!8}
\setbeamercolor{block body}{fg=Text,bg=Navy!3}
\setbeamercolor{block title example}{fg=Accent,bg=Accent!10}
\setbeamercolor{block body example}{fg=Text,bg=Accent!3}

% Teaching blocks: title is required; optional overlays use <2->, etc.
% Color changes stay local to each environment.
\newenvironment<>{definitionblock}[1]{%
  \setbeamercolor{block title}{fg=Navy,bg=BlueLight}%
  \setbeamercolor{block body}{fg=Text,bg=BlueLight!45!white}%
  \begin{block}#2{#1}%
}{\end{block}}
\newenvironment<>{exerciseblock}[1]{%
  \setbeamercolor{block title}{fg=Purple,bg=PurpleLight}%
  \setbeamercolor{block body}{fg=Text,bg=PurpleLight!45!white}%
  \begin{block}#2{#1}%
}{\end{block}}
\newenvironment<>{cautionblock}[1]{%
  \setbeamercolor{block title}{fg=Amber,bg=AmberLight}%
  \setbeamercolor{block body}{fg=Text,bg=AmberLight!45!white}%
  \begin{block}#2{#1}%
}{\end{block}}

%% -- FOOTNOTE CITATIONS -- %%

% Accent both the in-text marker and its matching footnote number.
\setbeamercolor{footnote mark}{fg=Accent}
% Cite a .bib entry in a full-width slide footnote, including inside columns.
% Usage: \sourcecite{key} or \sourcecite[p.~12]{key}.
\newcommand{\sourcecite}[2][]{\footnote[frame]{\fullcite[#1]{#2}}}

%% -- TEXT AND EQUATION HIGHLIGHTS -- %%

% Usage: \highlight[AmberLight]{Text} or \[ \highlight{E=mc^2} \].
% Short text highlights are single, unbreakable boxes.
% All highlight commands accept an optional background color.
\newcommand{\highlightedtext}[2][Accent!10]{%
  \begingroup
  \setlength{\fboxsep}{4pt}%
  \colorbox{#1}{#2}%
  \endgroup
}
% Preserve the surrounding math style (display, inline, or subscript).
\newcommand{\presentation@highlightmath}[3]{%
  \begingroup
  \setlength{\fboxsep}{8pt}%
  \colorbox{#1}{$\m@th#2#3$}%
  \endgroup
}
% A single command for text or math, selected by the surrounding mode.
\DeclareRobustCommand{\highlight}[2][Accent!10]{%
  \ifmmode
    \mathpalette{\presentation@highlightmath{#1}}{#2}%
  \else
    \highlightedtext[#1]{#2}%
  \fi
}
% Keep the original equation command for compatibility (display-style math).
\newcommand{\highlightedeq}[2][Accent!10]{%
  \presentation@highlightmath{#1}{\displaystyle}{#2}%
}

%% -- FIGURES AND SOURCE ATTRIBUTION -- %%

% Usage: \slidefigure[image options]{file}[caption][bib key][Adapted from].
% Figure helper: optional image options override the size defaults.
% Empty filename deliberately creates a placeholder; missing real files are errors.
% Caption and source key are optional. Use "Adapted from" for modified figures.
\NewDocumentCommand{\slidefigure}{O{} m O{} O{} O{Source}}{%
  \begin{figure}
    \centering
    \ifstrempty{#2}{%
      \fbox{\parbox[c][.3\textheight][c]{.85\linewidth}{\centering Your figure here}}%
    }{%
      \includegraphics[width=\linewidth,height=.52\textheight,keepaspectratio,#1]{#2}%
    }%
    \ifstrempty{#3}{}{\caption{#3}}%
    \ifstrempty{#4}{}{\par\smallskip{\scriptsize #5\sourcecite{#4}}}%
  \end{figure}%
}

%% -- PROGRESS BAR -- %%

% Frame progress: overlays share a number; the title frame is unnumbered.
% Clamp the fraction while the total is still being updated between runs.
\newif\iffullwidthprogress
\fullwidthprogressfalse
% Master switch: hide either bar style without hiding the footer.
\newif\ifprogress
\progresstrue
\newcommand{\fullprogressbar}{%
  \begingroup
  \pgfmathsetlengthmacro{\progresswidth}{%
    \paperwidth*min(1,max(0,\insertframenumber/max(1,\inserttotalframenumber)))}%
  \hbox to \paperwidth{%
    \rlap{\textcolor{Muted!20}{\rule{\paperwidth}{1.2pt}}}%
    \textcolor{Accent}{\rule{\progresswidth}{1.2pt}}\hss}%
  \endgroup
}
\newcommand{\progressbar}{%
  \begingroup
  \pgfmathsetlengthmacro{\progresswidth}{%
    12mm*min(1,max(0,\insertframenumber/max(1,\inserttotalframenumber)))}%
  \raisebox{.35ex}{%
    \rlap{\textcolor{Muted!20}{\rule{12mm}{1.2pt}}}%
    \rlap{\textcolor{Accent}{\rule{\progresswidth}{1.2pt}}}%
    \hspace{12mm}}%
  \endgroup
}

%% -- FOOTER: TITLE, SECTION, SUBSECTION, AND FRAME NUMBER -- %%

% The left 80% holds navigation text; the right 20% holds number/small bar.
% Keep short title and section labels concise to avoid overflow.
\setbeamercolor{footline}{fg=Muted,bg=white}
\setbeamertemplate{footline}{%
  \leavevmode%
  \vbox{%
  \hbox{%
    \begin{beamercolorbox}[wd=.8\paperwidth,ht=3ex,dp=1.5ex,leftskip=9mm,rightskip=2mm]{footline}%
      \usebeamerfont{footline}\insertshorttitle%
      \ifx\insertsectionhead\@empty\else
        \quad\textbar\quad\insertsectionhead%
        \ifx\insertsubsectionhead\@empty\else
          \enspace\textgreater\textgreater\enspace\insertsubsectionhead%
        \fi
      \fi
    \end{beamercolorbox}%
    \begin{beamercolorbox}[wd=.2\paperwidth,ht=3ex,dp=1.5ex,rightskip=9mm plus 1fil]{footline}%
      \hfill\usebeamerfont{footline}%
      \ifprogress
        \iffullwidthprogress\else
          \progressbar\hspace{2mm}%
        \fi
      \fi
      \insertframenumber
    \end{beamercolorbox}%
  }%
  \ifprogress
    \iffullwidthprogress
      \nointerlineskip\fullprogressbar
    \fi
  \fi
  }%
}

%% -- SECTION DIVIDERS -- %%

% Show only the section title, with the existing vertical centering.
% Dividers have no footer, do not count as frames, and are omitted in handouts.
% Toggle in the presentation preamble with \sectiondividersfalse / true.
\newif\ifsectiondividers
\sectiondividerstrue
\setbeamertemplate{section page}{
  \vbox to \textheight{
    \vfil\centering
    \usebeamerfont{section title}\usebeamercolor[fg]{section title}
    \insertsectionhead\par\vfil
  }
}
\AtBeginSection[]{
  \ifsectiondividers
    \begin{frame}<beamer>[plain,t,noframenumbering]
      \sectionpage
    \end{frame}
  \fi
}

%% -- TITLE SLIDE -- %%

% A title slide without a footer; content slide numbering starts at 1.
\newcommand{\maketitleslide}{%
  \begin{frame}[plain,noframenumbering]
    \titlepage
  \end{frame}%
}

%% -- END OF CLASS -- %%

\endinput
