# HexpUI

[Hexp](http://github.com/plexus/hexp) Widgets.

## Examples

```ruby
SearchForm = HexpUI::Form.build do
  textfield :query, title: "Search"
  submit 'Go!'
end

get '/' do
  SearchForm.new.to_html
end

# <form class="search_form form widget">
#   <div class="form-element">
#     <label for="query">Search</label><input type="text" value="" name="query">
#   </div>
#   <div class="form-element"><input type="submit" value="Go!"></div>
# </form>
```

```ruby
class HomeLink < Widget
  def initialize(title = "Home")
    @title = title
  end

  template do
    H[:a, {href: '/'}, title]
  end
end

HomeLink.new('Go Home').to_html # => <a href="/" class="home_link widget">Go Home!</a>
```

MIT License.
