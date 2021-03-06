module Docs
  class Rdoc
    class CleanHtmlFilter < Filter
      def call
        root_page? ? root : other
        doc
      end

      def root
        css('#methods + ul', 'h1', 'h2', 'li > ul').remove

        # Remove skipped items
        css('li > span').each do |node|
          node.parent.remove
        end
      end

      def other
        css('hr').remove

        # Remove paragraph/up links
        css('h1 > span', 'h2 > span', 'h3 > span', 'h4 > span', 'h5 > span', 'h6 > span').remove

        # Move id attributes to headings
        css('.method-detail').each do |node|
          next unless heading = node.at_css('.method-heading')
          heading['id'] = node['id']
          node.remove_attribute 'id'
        end

        # Convert "click to toggle source" into a link
        css('.method-click-advice').each do |node|
          node.name = 'a'
          node.content = 'Show source'
        end

        # Add class to differentiate Ruby code from C code
        css('.method-source-code > pre').each do |node|
          node['class'] = node.at_css('.ruby-keyword') ? 'ruby' : 'c'
        end

        # Remove code highlighting
        css('pre').each do |node|
          node.content = node.content
        end
      end
    end
  end
end
