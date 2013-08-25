# HexpUI

[Hexp](http://github.com/plexus/hexp) Widgets.

## Examples

The form builder :

```ruby
SearchForm = HexpUI::Form.build do
  textfield :query, title: "Search"
  submit 'Go!'
end

get '/' do
  SearchForm.new(action: '/foo').to_html
end

post '/foo' do
  # Only keep parameters of fields that exist
  filtered_params = SearchForm.new.filter(params)
end

# <form class="search_form form widget">
#   <div class="form-element">
#     <label for="query">Search</label><input type="text" value="" name="query">
#   </div>
#   <div class="form-element"><input type="submit" value="Go!"></div>
# </form>
```

Basic widget, classes are set automatically

```ruby
class HomeLink < Widget
  def initialize(title = "Home", options = {})
    super options
    @title = title
  end

  template do
    H[:a, {href: '/'}, title]
  end
end

HomeLink.new('Go Home').to_html # => <a href="/" class="home_link widget">Go Home!</a>
```

Container widgets : use the `Container[]` style constructor, and the `contents` method :

```ruby
class List < Widget
  template do
    H[:ul, Array(contents).map {|entry| H[:li, entry]}]
  end
end

List['one', 'two', 'three'].to_html
```

MIT License.
