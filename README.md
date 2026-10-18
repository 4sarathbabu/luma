# Luma — A Simple LaTeX Beamer Presentation Template

A simple Beamer template for lectures and talks, with navy and teal colors,
footnote references, speaker notes, and optional progress bars.

## Quick start

1. Keep the template files together in one folder.
2. Edit **`presentation.tex`**: replace the title, author, institution, and sample slides.
3. Add your references to **`references.bib`**.
4. Run:

   ```sh
   make
   ```

5. Open **`presentation.pdf`**.

Replace the sample bibliography entry and any example contact details before
sharing your presentation.

**Requirements:** a LaTeX installation with pdfLaTeX, BibTeX, latexmk, Beamer,
Latin Modern, booktabs, biblatex, pgfpages, and appendixnumberbeamer.

## Choose an output

You can build all versions from the same slide content—no preamble edits needed.

| Command | PDF | What it contains |
| --- | --- | --- |
| `make` or `make slides` | `presentation.pdf` | Audience slides with reveals; no notes |
| `make handout` | `presentation-handout.pdf` | Reveals combined; no notes or section dividers |
| `make notes` | `presentation-notes.pdf` | Slides on the left; private notes on the right |
| `make all` | All three | Every output mode |

### Rebuild and clean up

```sh
make rebuild    # Force all three versions to rebuild
make clean      # Remove auxiliary files; keep PDFs
make distclean  # Remove auxiliary files and PDFs; keep sources
```

### Overleaf or manual compilation

On Overleaf, upload the source files and any images. Select `presentation.tex`,
`presentation-handout.tex`, or `presentation-notes.tex` as the main document.

To compile manually:

```sh
pdflatex presentation.tex
bibtex presentation
pdflatex presentation.tex
pdflatex presentation.tex
```

For another output mode, substitute its filename/basename in all four commands.
This template uses **BibTeX**, not Biber.

## Where to make changes

| File | Purpose |
| --- | --- |
| `presentation.tex` | Your content, title details, and presentation settings |
| `luma.cls` | Shared layout, colors, typography, and custom commands |
| `references.bib` | Bibliography entries |
| `presentation-handout.tex` | Selects handout mode and loads your content |
| `presentation-notes.tex` | Selects presenter-note mode and loads your content |
| `Makefile` | Build and cleanup commands |
| `figures/` | Images, plots, and optional logo |

For a new talk, copy the folder and edit `presentation.tex`. The two driver
files load it automatically; you do not need to copy content into them.

## Common settings

Put these settings in the **preamble** of `presentation.tex`, before
`\begin{document}`. Enable the choice you want and comment out conflicting settings.

### Progress bar

```text
\progresstrue               % Show progress
\fullwidthprogresstrue      % Thin bar across the bottom
```

Other choices:

```text
\fullwidthprogressfalse     % Small bar beside the slide number
\progressfalse             % Hide either bar; keep the footer
```

### Section dividers and closing slide

```text
\sectiondividersfalse       % Disable automatic section-divider slides
\sectiondividerstrue        % Enable them (class default)
\showclosingfalse           % Hide the optional closing slide
```

Divider styling lives in `luma.cls`. Dividers are unnumbered and omitted from
handouts. The closing-slide switch is defined in `presentation.tex`; change its
existing setting there and replace the sample contact details if you keep it.

### Slide size, colors, and footer

```text
\documentclass[aspectratio=43]{luma} % Use 4:3 instead of the default 16:9
\definecolor{Accent}{HTML}{00897B}  % Customize the accent color
\title[Short title]{Full presentation title}
\section[Short section]{Full section title}
\subsection[Short subsection]{Full subsection title}
```

Replace the existing document-class line rather than adding a second one.
Short titles keep the footer readable. The default font is Latin Modern Sans.
To hide the entire footer, use `\setbeamertemplate{footline}{}`.

### Two slides per printed page

Uncomment the layout inside the existing handout conditional:

```text
\ifdefined\handoutbuild
  \pgfpagesuselayout{2 on 1}[letterpaper,border shrink=5mm]
\fi
```

Use `a4paper` if preferred. This affects the handout build only.

## Reveals and speaker notes

### Reveal content step by step

```text
First point.
\pause
Second point.
```

For more control:

```text
\begin{itemize}
  \item<1-> Visible from step 1.
  \item<2-> Visible from step 2.
\end{itemize}

\uncover<3->{Visible from step 3 onward.}
```

Steps restart at 1 in each frame. Handout mode combines these reveals by default.
For replacement content, use `handout:0` to omit versions you do not want printed:

```text
\only<1|handout:0>{Think about the answer.}
\only<2->{The answer is 42.}
```

### Add private notes

Inside a frame, write:

```text
\note{Ask for an example before revealing the answer.}
```

Build with `make notes`. The generated PDF places each slide and its speaker
notes side by side on a single page, so a standard PDF viewer displays both
together. To show slides on one screen and notes on another, open the PDF in
[**Pympress**](https://pympress.github.io/), select right-side notes, and use an extended desktop rather than
display mirroring. The audience and handout builds do not include speaker notes.

### Add backup slides

Place extra material after the conclusion:

```text
\appendix
\progressfalse
\section{Backup slides}

\begin{frame}{Additional derivation}
  Supporting details for questions.
\end{frame}
```

The template loads `appendixnumberbeamer` to separate backup numbering from the
main slide total. Backup slides are still included in handouts.

## Highlights and blocks

### Highlight text or an equation

```text
\highlight[AmberLight]{Key assumption}

\[
  \highlight[BlueLight]{E = mc^2}
\]
```

`\highlight` detects text or math automatically. `\highlightedtext` and
`\highlightedeq` are also available. Text highlights are intended for short
phrases and do not wrap across lines.

| Pale background | Matching text color | Suggested use |
| --- | --- | --- |
| `TealLight` | `Teal` | Key ideas |
| `BlueLight` | `Blue` | Definitions |
| `AmberLight` | `Amber` | Assumptions or cautions |
| `RoseLight` | `Rose` | Errors or exceptions |
| `PurpleLight` | `Purple` | Exercises or special results |
| `GrayLight` | `Muted` | Neutral emphasis |

Use `\textcolor{Purple}{Important result}` for colored text, or a tint such as
`\highlight[Teal!15]{Custom tint}` for a custom background.

### Use a consistent block style

| Environment | Appearance |
| --- | --- |
| `definitionblock` | Navy and pale blue |
| `exampleblock` | Teal |
| `exerciseblock` | Purple |
| `cautionblock` | Amber |

```text
\begin{exerciseblock}<2->{Try it yourself}
  Find the mean of 3, 5, and 10.
\end{exerciseblock}
```

The title is required. Omit `<2->` to show the block immediately.

## Figures, tables, and references

### Insert a figure

```text
\slidefigure{figures/plot.pdf}[Short caption][reference-key][Adapted from]
\slidefigure[height=.4\textheight]{figures/photo.jpg}
```

The helper fits the available column width, limits height, and preserves proportions.

| Argument | Required? | Purpose |
| --- | --- | --- |
| `[image options]` | No | Override width or height |
| `{file}` | Yes | Image path; `{}` gives a sample placeholder |
| `[caption]` | No | Short caption |
| `[source key]` | No | Entry from `references.bib` |
| `[source wording]` | No | Defaults to `Source` |

Use `Adapted from` for modified figures and `Reproduced from` for unchanged ones.
A nonempty filename must exist; missing images cause a build error.
Prefer vector PDFs for plots, include axis units, and use markers or line styles
as well as color.

### Add a table

The class loads `booktabs`. The sample table in `presentation.tex` demonstrates
column alignment, spacing, captions, and source attribution. Use `\toprule`,
`\midrule`, and `\bottomrule` for clean horizontal rules without vertical lines.

### Cite a reference in a footnote

Add entries to `references.bib`, then cite their keys:

```text
Your statement\sourcecite{reference-key}.
Your statement\sourcecite[p.~12]{reference-key}.
```

Each use prints the full reference at the bottom of the slide. A final reference
list is optional; see the commented example at the end of `presentation.tex`.

### Include a title-slide logo

```text
\titlegraphic{
  \includegraphics[width=2cm,height=1.5cm,keepaspectratio]{figures/logo.pdf}
}
```

Put this in the preamble and use the actual filename of your logo. It appears
only on the title slide. The supplied sample logo is fictional.

## Before presenting

- [ ] Run `make all`; check for undefined citations or overfull boxes.
- [ ] Replace sample content, bibliography entries, contact details, and links.
- [ ] Check figure labels, equations, footnotes, and long footer titles.
- [ ] Review reveals and the combined handout, especially replacement content.
- [ ] Share the audience or handout PDF, not the private notes PDF.
- [ ] Test Pympress and the projector with extended displays.

## Developer and contact

**Developed and maintained by Sarath Babu.**

Luma grew out of a desire for a simple, readable, and reusable presentation
template for lectures and talks. Suggestions, bug reports, and contributions
are welcome.

- **Email:** [your.name@example.com](mailto:your.name@example.com)

## Acknowledgments

Thank you to ChatGPT by OpenAI for assistance with developing and refining
the template, exploring design choices, and preparing the documentation.
Luma also builds on the work of the LaTeX, Beamer, and package maintainers.

## License

Copyright (C) 2026 Sarath Babu.

Luma is free software licensed under the **GNU General Public License,
version 3 only** (`GPL-3.0-only`). You may redistribute and modify it under
the terms of that license.

Luma is distributed without any warranty, including the implied warranties of
merchantability or fitness for a particular purpose. See [LICENSE](LICENSE)
for the complete terms.

Third-party packages and any externally supplied logos, figures, or other
materials retain their respective licenses.


