module HexpUI
  class Widget
    include Hexp

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

      def [](*contents)
        if contents.size == 1
          contents = contents.first
        end
        self.new.tap do |widget|
          widget.contents = contents
        end
      end
    end

    attr_reader :options
    attr_accessor :contents

    def initialize(options = {})
      @options = options
    end

    def to_hexp
      instance_eval(&self.class.lookup_template).merge_attrs(
        class: extra_classes,
      ).merge_attrs(options.reject {|key,_| key == :class})
    end

    def extra_classes
      class_list = Array(options[:class])
      klass = self.class
      while klass != Object
        unless klass.class_options.fetch(:no_auto_class, []).include?(klass)
          class_list << underscore(klass.name)
        end
        klass = klass.superclass
      end
      class_list.join(' ')
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
