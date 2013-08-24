module HexpUI
  class Menu < Widget
    attr_reader :items

    def initialize(items)
      @items = items
    end

    def render_items
      items.map do |item|
        H[:li, H[:a, {href: item[:url]}, item[:text]]]
      end
    end

    template do
      H[:nav, [
          H[:ul, {class: 'main'}, render_items]
        ]
      ]
    end
  end
end
