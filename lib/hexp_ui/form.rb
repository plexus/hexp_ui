module HexpUI
  class Form < Widget

    class << self
      attr_accessor :elements

      def build(&blk)
        raise unless blk
        FormBuilder.new(&blk).form_class
      end
    end

    attr_reader :values

    def initialize(model_or_params = nil)
      @values = Hash[
        self.class.elements.map do |type, name, opts|
          if model_or_params
            value = model_or_params[name]
            options = element_opts(name)
            if options
              value = nil
              options.each do |option_value, text|
                if option_value.to_s == model_or_params[name].to_s
                  value = option_value
                  break
                end
              end
            end
          end
          [name, value]
        end
      ]
    end

    def element_opts(element_name)
      self.class.elements.select do |type, name, opts|
        element_name == name
      end[2]
    end

    template do
      H[:form, elements]
    end

    def elements
      self.class.elements.map do |type, name, opts|
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

    private

    def select_option(name, value, text)
      attrs = {value: value}
      attrs[:selected] = 'selected' if @value[name] == value
      H[:option, attrs, text]
    end
  end

  class FormAspects < Aspector::Base
    HAS_LABEL = [:select, :textfield]
    HAS_NAME  = [:select, :textfield]

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
