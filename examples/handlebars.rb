# (chruby "ruby-2")
$:.unshift '/home/arne/github/hexp_ui/lib'
$:.unshift '/home/arne/github/hexp/lib'

require 'hexp_ui'

class Foo < HexpUI::Widget
  template do
    H[:div, {name: name}, [
        H[:ul, foos.map do |foo|
            H[:li, foo.property]
          end
        ]
      ]
    ]
  end
end

puts Foo.handlebars.to_html

# => <div name="{{name}}"><ul>{{#each foos}}<li>{{property}}</li>{{/each}}</ul></div>
