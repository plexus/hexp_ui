module HexpUI
  class Form < Widget

    DEFAULT_OPTIONS = {
      method: 'POST',
      :'accept-charset' => 'UTF-8'
    }.freeze

    class << self
      attr_accessor :elements

      def build(&blk)
        raise unless blk
        FormBuilder.new(self, &blk).form_class
      end
    end

    attr_reader :values

    def initialize(options = {})
      super DEFAULT_OPTIONS.merge(options)
      @values = element_values
    end

    def filter(model_or_params)
      elements.each do |_, name, _|
        @values[name] = model_or_params[name] if model_or_params[name]
      end
      @values
    end

    def elements
      self.class.elements
    end

    def element_values
      {}.tap do |values|
        elements.each do |_, name, _|
          if options = element_opts(name) && options.has_key?(:value)
            if options[:value].respond_to? :call
              values[name] = options[:value].call
            else
              values[name] = options[:value]
            end
          end
        end
      end
    end

    def element_opts(element_name)
      elements.select do |type, name, opts|
        element_name == name
      end[2]
    end

    template do
      H[:form, render_elements]
    end

    def render_elements
      elements.map do |type, name, opts|
        H[:div, {class: 'form-element'}, self.send(type, name, opts)]
      end
    end

    def textfield(name, opts)
      H[:input, {type: "text", value: @values[name]}]
    end

    def select(name, opts)
      H[:select, opts[:options].map do |value, text|
          select_option(name, value, text)
        end
      ]
    end

    def submit(name, opts)
      H[:input, type: 'submit', value: name]
    end

    def hidden(name, opts)
      H[:input, type: 'hidden', value: @values[name]]
    end

    private

    def select_option(name, value, text)
      attrs = {value: value}
      attrs[:selected] = 'selected' if @value[name] == value
      H[:option, attrs, text]
    end
  end

  class FormAspects < Aspector::Base
    HAS_LABEL = [:select, :textfield]
    HAS_NAME  = [:select, :textfield, :hidden]

    around HAS_LABEL do |proxy, name, opts|
      [
        H[:label, {for: name}, opts[:title]],
        proxy.call(name, opts)
      ]
    end

    around HAS_NAME do |proxy, name, opts|
      proxy.call(name, opts).attr('name', name)
    end
  end

  FormAspects.apply(Form)
end
