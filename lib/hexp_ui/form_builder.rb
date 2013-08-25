module HexpUI
  class FormBuilder
    # All the ones that Drupal's form API implements
    # https://api.drupal.org/api/drupal/developer!topics!forms_api_reference.html/7
    # TYPES = %w[checkbox checkboxes date fieldset file machine_name managed_file
    #   password password_confirm radio radios select tableselect text_format
    #   textarea textfield vertical_tabs weight].map(&:to_sym)

    TYPES = %w[select textfield submit].map(&:to_sym)

    attr_reader :elements

    def initialize(&blk)
      @elements = []
      instance_eval(&blk)
    end

    TYPES.each do |type|
      define_method type do |name, opts = {}, &blk|
        @elements << [type, name, opts]
      end
    end

    def form_class
      Class.new(Form).tap do |klz|
        klz.elements = @elements
      end
    end
  end
end
