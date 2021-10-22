## Shotgunner

![Gem](https://img.shields.io/gem/dt/handleit.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/nucleom42/handleit.svg)
![Gem](https://img.shields.io/gem/v/handleit.svg)

**Problem:**

* Want to have JS Promise-like way of handling logic execution, with ability to chain handlers?

**Solution:**

* Use wrap execution class within Handle.it block and chain handlers in the Promise manner

**Notes:**

* Could be good matching in rails controllers, when it is important to have declarative way of handling execution. 

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
  # ...
  def auth
    Handle.it { AuthService.authenticate! }
      .with { |res| redirect_to wellcome(user), notice: 'Welcome!'}
      .on_fail { |e| redirect_to login(user), notice: "Authentication error: #{e.message}" }
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

=> "some_cool_string bla"

# Handle.it on_fail
pry(main)> Handle.it { Service.error_raiser }
pry(main)>  .with { |res| res + " bla" }
pry(main)>  .with { |res| pp res }
pry(main)>  .on_fail { |e| pp e }

=> #<StandardError: StandardError>

```