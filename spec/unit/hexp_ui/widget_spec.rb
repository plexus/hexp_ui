require 'spec_helper'

describe HexpUI::Widget do
  class FooWidget < HexpUI::Widget
    template do
      H[:nav, "Foo says hi!"]
    end
  end

  it 'should add classes' do
    expect(FooWidget.new.to_hexp.class_list).to eq ['widget', 'foo_widget']
  end
end
