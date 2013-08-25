module HexpUI
  class Widget
    include Hexp

    attr_reader :options

    class << self
      def no_auto_class
        class_options[:no_auto_class] ||= []
        class_options[:no_auto_class] << self
      end

      def class_options
        @class_options ||= {}
      end

      def template(&block)
        @template ||= block
      end

      def lookup_template
        template || superclass.template
      end
    end

    def intialize(options = {})
      @options = options
    end


    def to_hexp
      add_classes(instance_eval(&self.class.lookup_template))
    end

    def add_classes(hexp)
      class_list = []
      klass = self.class
      while klass != Object
        class_list << underscore(klass.name) unless klass.class_options.fetch(:no_auto_class, []).include?(klass)
        klass = klass.superclass
      end
      hexp.merge_attrs(class: class_list.join(' '))
    end

    private

    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/.*::/, '')
      #word.gsub!(/(?:([A-Za-z\d])|^)(#{inflections.acronym_regex})(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
