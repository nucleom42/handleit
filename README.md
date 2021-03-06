## Handleit

![Gem](https://img.shields.io/gem/dt/handleit.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/nucleom42/handleit.svg)
![Gem](https://img.shields.io/gem/v/handleit.svg)

**Problem:**

* Want to have JS Promise-like way of handling logic execution, with ability to chain handlers, plus useful additions like guard adn rollback?

**Solution:**

* Use wrap execution class within Handle.it block and chain handlers in the Promise manner

**Notes:**

* Could be good matching in rails controllers, when it is important to have declarative way of handling execution.
* Use **guard** feature with 'it' method args, like:
```ruby
def valid?
  false
end

Handle.it(when: valid?, not_valid_error: 'User not found')
  .with { |r| redirect_to wellcome(user), notice: 'Welcome!' }
  .on_fail { |e| pp e.message }

=> 'User not found'
```
if valid returns 'false', it goes to on_fail block with specific error message

* Use **rollback** feature with 'with' method args, like:
```ruby
Handle.it { "Ruby rules" }
  .with(on_fail: :rollback) { |res| res.upcase.split.unknow_method_call }
  .result

=> 'Ruby rules'
```
if you want to have last successful result neglecting errors.

## Install

```ruby

gem install handleit

```

## Rails

```ruby

gem 'handleit', require: %w[handle]

```

## Examples

```ruby
class UsersController < ApplicationController
  def auth
    Handle.it(when: valid?, not_valid_error: 'User not found') do
      AuthService.authenticate!
    end 
      .with { |res| redirect_to wellcome(user), notice: 'Welcome!'}
      .on_fail { |e| redirect_to login(user), notice: "Authentication error: #{e.message}" }
  end
  
  def valid?
    # some validation logic
  end
end
# ...

class Service
  class << self
    def some_cool_logic
      "some_cool_string"
    end
    
    def error_raiser
      raise StandardError
    end
  end
end
# ...

# Handle.it with
pry(main)> Handle.it { Service.some_cool_logic }
pry(main)>  .with { |res| res + " bla" }
pry(main)>  .with { |res| pp res }
pry(main)>  .on_fail { |e| pp e }
pry(main)>  .result

=> "some_cool_string bla"

# Handle.it shortcut methods
pry(main)> H.it { Service.some_cool_logic }
pry(main)>  .> { |res| res + " bla" }
pry(main)>  .> { |res| pp res }
pry(main)>  .e { |e| pp e }
pry(main)>  .<=

=> "some_cool_string bla"

# Handle.it on_fail
pry(main)> Handle.it { Service.error_raiser }
pry(main)>  .with { |res| res + " bla" }
pry(main)>  .with { |res| pp res }
pry(main)>  .on_fail { |e| pp e }

=> #<StandardError: StandardError>

# pipelining result
pry(main)> Handle.it { "Elixir rocks" }
pry(main)>  .with { |res| res.size - 1 }
pry(main)>  .with { |res| res.upcase.split.first }
pry(main)>  .result

=> 5

# rollback result instead of sending it into on_fail block, so it returns latest successful
pry(main)> Handle.it { "Elixir rocks" }
pry(main)>  .with { |res| res.size - 1 }
pry(main)>  .with(on_fail: :rollback) { |res| res.upcase.split.unknow_method_call }
pry(main)>  .on_fail { |e| pp e }
pry(main)>  .result

=> 11
```