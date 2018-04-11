# Sam

[![Maintainability](https://api.codeclimate.com/v1/badges/a8c24394996582c1b59f/maintainability)](https://codeclimate.com/github/VAGAScom/sam/maintainability)
[![Dependency Status](https://beta.gemnasium.com/badges/github.com/VAGAScom/sam.svg)](https://beta.gemnasium.com/projects/github.com/VAGAScom/sam)


![Sam](https://vignette.wikia.nocookie.net/looneytunes/images/c/c9/Sam_Sheepdog_300-1-.gif/revision/latest?cb=20170411195916)

Sam, the shepphered, will look after your unicorns so that they play nice with `upstarts` and even `systemds`. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sam'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sam

## Usage

**Sam** comes with the following commands:

1. `unicorn start`: starts an  `unicorn` instance
2. `unicorn stop`: stops an `unicorn` instance
3. `unicorn monitor`: start a monitoring loop over the running `unicorn` instance. It will forward the signals `HUP, USR2, TERM, QUIT, TTIN, TTOU` to the `unicorn` instance. `HUP` will do an graceful reload of the application
4. `unicorn reload`: reloads the `unicorn` instance by issuing a `USR2` followed by a `QUIT` signal a few seconds later
5. `unicorn run`: starts and monitors an `unicorn` instance

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vagascom/sam. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sam project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sam/blob/master/CODE_OF_CONDUCT.md).
