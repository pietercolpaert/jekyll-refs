# jekyll-refs

_Project status: tweaking a proof of concept, help appreciated_

Bibliographic references in [RDFa](https://en.wikipedia.org/wiki/RDFa) using the [cito vocabulary](http:/purl.org/spar/cito/) and the [bibo ontology](http://purl.org/ontology/bibo/)

This makes sure you can write papers, blog posts or books in HTML using jekyll to generate the references for you by describing the references once in a [JSON-LD](http://json-ld.org) file.

## Installing it

 1. Add the contents of the `_plugins` folder (more specifically `refs.rb`) in your own `_plugins` folder.
 2. In your `_data` folder, add a file called `references.json`. This file will be a [JSON-LD](http://json-ld.org) file that adheres to the [bibo ontology](http://purl.org/ontology/bibo/). Follow the example from this repository as a specific profile/JSON structure is expected.

## Using it

### Citing something

 1. Make sure it's correctly described in your `_data/references.json` file
 2. Add a citation to a chunk of text using `start_citation` (`sc` in short) and `end_citation` (`ec` in short). Starting the citation takes two arguments: the [cito citation type](http:/purl.org/spar/cito/) and the URI of the document also used in the references file
```
{% sc cites https://tools.ietf.org/html/rfc4180 %}comma-separated values{% ec %}
```

### Create a references list

At e.g., the end of your document, you can have a list of references that were referred in the page. Include it as follows:
```
{% references %}
```

It will also add a `<h2>References</h2>` title.

### Using CSS styles to mark-up the citations

#### Protip 1: hide references on the Web, show them in print

References are great when you print a page, yet on the Web, we can just follow the link instead of having to read where it comes from. You can thus hide every `[x]` that is created after a citation and hide the references list:

```css
@media screen, handheld {
    .reference {
        display: none;
    }
    
    .references {
        display: none;
    }
}
```

#### Protip 2: Nice references list for print

Make sure page breaks happen at the right location, and adds a gray color to the references itself. As we use a definitions list (`<dd>` and `<dt>`), this can be shown in a nicer way as well, just like an LNCS or ACM paper.

Feel free to tweak this example:

```css
/* References */
.references {
    color: gray;
}

.references dd {
    page-break-before: avoid;
}

.references dt {
    page-break-after: avoid;
}

.references dd span {
    page-break-before: avoid;
}

.references dt {
    display: inline-block;
    float: left;
    width: 17px;
    text-align: right;
    page-break-after: avoid;
    clear: none;
}

.references dd {
    margin: 0 0 0 33px;
    padding: 0 0 0.35em 0;
}
```

### Protip 3: give your different type of citations a different style

E.g., when you disagree with something, but the reference (`[x]`) in gray so it becomes less visible.

```css
.reference .disagreesWith {
    color: gray;
}
```

## Example

In the `_sites` folder you will find a compiled version of how we see you could use this references libary.

The source file for this is in index.html. Try the example yourself with `jekyll serve`.
