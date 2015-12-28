# Errant

An implementation of [Railway-Oriented Programming](http://fsharpforfunandprofit.com/posts/recipe-part2/) for Ruby.

## Usage

### `capturing`

You can use Errant to capture and wrap exceptions in the natural flow of your code. If an exception is *expected*, after all, it's not really an exception; it's a value which you are anticipating and can deal with. This style uses the `capturing` method:

```ruby
x = Errant.capturing(StandardError) { 35 }
# => #<Errant::Success:0x000000011136f8 @exceptions=[StandardError], @value=35>

x = x.flat_map { |n| n * 2 }
# => #<Errant::Success:0x000000018eab10 @exceptions=[StandardError], @value=70>

x = x.flat_map { fail "Oops! }
# => #<Errant::Failure:0x000000018bad48 @value=#<RuntimeError: oops!>>
```

If you specify a list of exceptions in your call to `capturing`, exceptions which don't fit in that list will be raised as usual.

```ruby
x = Errant.capturing(ArgumentError) { 35 }
# => #<Errant::Success:0x000000011136f8 @exceptions=[StandardError], @value=35>

x = x.flat_map { fail "Oops!" }
# RuntimeError:  oops
```

### Direct Instantiation

You can also use Errant to explicitly return `Success` and `Failure` objects. For conciseness, this utilizes the `[]` methods, and should generally be preferred to `capturing` when the logical branching necessary to determine success or failure is complex. For example, a successful value might look like this:

```ruby
x = Errant::Success[35]
# => #<Errant::Success:0x000000011136f8 @exceptions=[StandardError], @value=35>
```

You can also instantiate failures directly:

```ruby
x = Errant::Failure["missing vital data"]
# => #<Errant::Failure:0x000000018a7568 @value="missing vital data">
```

### Working With Values

The `flat_map` method should be favored when working with wrapped values. It is equivalent to the `>>=` (bind) operator in Haskell, or `flatMap` in Scala.

```ruby
x = Errant::Success[5]
  .flat_map { |n| n * 2 }
  .flat_map { |n| n * 5 }
  .flat_map { |n| n.to_s + "!" }
```

`flat_map`, called on an `Error` value, will do nothing.
