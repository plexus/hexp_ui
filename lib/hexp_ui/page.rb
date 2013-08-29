module HexpUI
  class Page < Widget
    class << self
      def header
        @header ||= []
      end

      def title(title)
        header << H[:title, title]
      end

      def charset(set)
        header << H[:meta, charset: set]
      end

      def author(author_link)
        header << H[:link, rel: 'author', href: author_link]
      end

      def stylesheet_link(link)
        header << H[:link, rel: 'stylesheet', href: link]
      end

      def javascript_link(link)
        header << H[:script, type: 'text/javascript', src: link]
      end
    end

    def header
      (self.class.superclass.respond_to?(:header) ? self.class.superclass.header : []).concat(
        self.class.header
      )
    end

    def to_hexp
      H[:html, [
          H[:head, header],
          H[:body, {id: page_id}, super]
        ]]
    end

    def page_id
      underscore(self.class.name).sub(/_page/, '')
    end

    def extra_classes
      nil
    end
  end
end
