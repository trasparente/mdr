---
---
Kramdown
========
{:.no_toc}
- toc
{:toc}

> <https://kramdown.gettalong.org/>

Kramdown is the default Markdown renderer for Jekyll and use the _GitHub Flavored Markdown (GFM) processor_.

Classes ids and attributes can be added with an Inline Attribute List (IAL) `{: .class #id key="value"}`{:.language-md}

## Table of contents

Render an ordered or unordered nested list (with default ID `markdown-toc`) of the headers in the page.  

Add an IAL with reference name `toc` to a one element ordered or unordered list.
```md
* toc / 1. toc
{:toc}
```

Exclude headers from the TOC with the class `no_toc`.
```md
## Excluded header
{:.no_toc}
```

Colors
------
{% assign col = "red,orange,yellow,green,forest,cyan,blue,violet,purple,magenta,pink" | split: ',' %}
{% for c in col %}<span class='color-{{c}}'>.color-{{c}}</span>
{% endfor %}

Code
----
Inline CSS: `body[hidden]{ color: hsl(30, 40%, 50%);}`{:.language-css}  
Inline HTML: `<p data-type='ciro'></p>`{:.language-html}

__Fenced__  
<code>```yml ... ```</code>
```yml
city: 1
caos: "ok"
array:
  - 1
  - 2
  - three
array: [1, 2, "three"]
```

__Indented by 4 spaces__  
`{:.language-html}` ... emply line

{:.language-html}
    <body>
      <a href="#url">text</a>
    </body>

__Kramdown code block__  
`~~~ yml ... ~~~`
~~~ coffee
console.log a, 'error'
c = (arg) -> arr.index()
$('body').append(arr)
~~~

## Blockquotes

> Example with cite attribute (source url)
{:cite="https://example.com"}

{% for color in colors %}
<blockquote class="{{ color }}">.{{ color }}</blockquote>
{% endfor %}

And **Inline quotation element** like <q cite="https://example.com">this</q>.

```html
<q cite="{source url}">Quote</q>
```

## Typography

|Kramdown|Result
|:---|:---
|`__` `**`|__Bold__
|`_` `*`|_Italic_

|HTML|Result
|:---|:---
|`del`|<del>Deleted</del>
|`ins`|<ins>Inserted</ins>
|`abbr[title]`|<abbr title="Abbreviation">Abbreviation</abbr>
|`cite`|<cite>Cite</cite>
|`kbd`|<kbd>Ctrl + S</kbd>
|`samp`|<samp>Sample</samp>
|`mark`|<mark>Highlighted</mark>
|`s`|<s>Strikethrough</s>
|`u`|<u>Underline</u>
|`small`|<small>small</small>
|`sub`|Text<sub>Sub</sub>
|`sup`|Text<sup>Sup</sup>

## Abbreviations

Abbreviated text is written normally and below the text add  
`*[normally]: Abbreviation`

Rendered HTML code:
```html
<abbr title="Abbreviation">normally</abbr>
```

*[normally]: Abbreviation

## Footnotes

Text is followed[^1] by `[^1]` and below the text add `[^1]: Footnote`.  
The note will be added at the end[^where] of the document.

Rendered HTML code:
```html
<sup id="fnref:1" role="doc-noteref">
  <a href="#fn:1" class="footnote" rel="footnote">1</a>
</sup>
```

```html
<div class="footnotes" role="doc-endnotes">
  <ol>
    <li id="fn:1" role="doc-endnote">
      <p>... <a href="#fnref:1" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    ...
  </ol>
</div>
```

[^1]: Some *markdown* footnote definition
[^where]: End of page

## Definition lists

Elements: `<dl><dt><dd>`{:.language-html}  
Markdown: `: `&nbsp;for the descriptions  
- Empty line before new term
- End with a definition

```md
term
: definition
: another definition

another term
and another term
: and a definition for the term
```
term
: definition
: another definition

another term
and another term
: and a definition for the term