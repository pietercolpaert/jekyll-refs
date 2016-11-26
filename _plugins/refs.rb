# References library
# Author: Pieter Colpaert
#
# First, you will need a file _data/references.json, which describes using the bibo ontology
#
# Cite something as follows:
#  {% start_citation citesAsAuthority https://tools.ietf.org/html/rfc4180 %} {{"csv"|abbrf}} {% end_citation %}
# 
# You can get a list of all citation type possibilities at http://purl.org/spar/cito
#
# If you want a list of all used references in a page, use the {% references %} command. You can tweak the output below...
#
# You can use the cito terms also as classes in css to mark-up a link differently:
#  * 
# 
#

require 'json'
module Jekyll
  class CitationStartTag < Liquid::Tag
    @@currentCitationKey = ""
    @@currentPage = ""
    @@citations = {}
    def self.citationsOnCurrentPage
      @@citations[@@currentPage]
    end
    
    def self.citations
      @@citations
    end
    
    def self.current_citation
      @@citations[@@currentPage][@@currentCitationKey]
    end
    def initialize(tag_name, arguments, tokens)
      super
      args = arguments.strip.split(' ')
      @citoCitationType = args.shift
      @uri = args.shift
    end

    def render(context)
      page = context['page']['path']
      @@currentPage = page
      if !@@citations[page]
        @@citations[page] = {}
      end
      @@currentCitationKey = @uri
      if !@@citations[page][@uri]
        @@citations[page][@uri] = {
          index: @@citations[page].length+1,
          number: 1
        }
      else
        @@citations[page][@uri][:number] += 1
      end
      # To do: add a title of the work here and how we see this work (Agree with? Disagree with?)
      "<a href=\""+ @uri + "\" rel=\"http://purl.org/spar/cito/" + @citoCitationType + "\" class=\"" + @citoCitationType +"\">"
    end
  end
  class CitationEndTag < Liquid::Tag
    def initialize(tag_name, arguments, tokens)
      super
    end

    def render(context)
      "</a><span class=\"reference\">&nbsp;[#{CitationStartTag.current_citation[:index]}]</span>"
    end
  end

  class References < Liquid::Tag
    def initialize(tag_name, arguments, tokens)
      super
    end
    
    def render(context)
      page = context['page']['path']
      data_root = File.dirname(__FILE__)+"/../_data/"
      jsondoc = JSON.load(File.open(File.join(data_root, "references.json")))
      references = {}
      # Transform json-ld into usable array
      jsondoc["@graph"].each do | document |
        authors = document["authors"]
        publisher = document["publisher"] || ""
        # RDFa annotated string
        references[document["@id"]] = "<span property=\"dct:creator\">" + authors.join('</span>, <span property=\"dct:creator\">') + "</span>: ``<a href=\"#{document['@id']}\"><cite property=\"dct:title\">" + document["title"] + "</cite></a>'', #{publisher} (<span property=\"dcterms:created\">#{document["year"]}</span>)"
      end

      if CitationStartTag.citations[page]
        start = "<section class=\"references\"><h2>References</h2><dl compact=\"true\">"
        CitationStartTag.citations[page].each do | uri, citation |
          if references[uri]
            start += "<dt>[#{citation[:index]}]</dt><dd about=\"#{uri}\">#{references[uri]}<dd>"
          end
        end
        ending = "</dl></section>"
      else
        start = ""
        ending = ""
      end
      start+ending
    end
  end
end

Liquid::Template.register_tag('start_citation', Jekyll::CitationStartTag)
Liquid::Template.register_tag('end_citation', Jekyll::CitationEndTag)
Liquid::Template.register_tag('sc', Jekyll::CitationStartTag)
Liquid::Template.register_tag('ec', Jekyll::CitationEndTag)
Liquid::Template.register_tag('references', Jekyll::References)
