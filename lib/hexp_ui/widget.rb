module HexpUI
  class Widget
    include Hexp

    def self.template(&block)
      @template ||= block
    end

    def to_hexp
      add_classes(self.class.template.())
    end

    def add_classes(hexp)
      class_list = []
      klass = self.class
      while klass != Object
        class_list << klass.name.gsub(/(.)([A-Z][^A-Z])/, '\1_\2').downcase.gsub(/.*::/, '')
        klass = klass.superclass
      end
      hexp.merge_attrs(class: class_list.join(' '))
    end
  end
end
