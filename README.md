# Rails Utils [![Gem Version][version-badge]][rubygems] [![Build Status][travis-badge]][travis]

Rails helpers based on opinionated project practices. Useful for structuring CSS and JavaScript,
display title of the page, and flash messages with Bootstrap.

## Installation

Add rails_utils to your application's Gemfile:

    gem 'rails_utils'

And then execute:

    $ bundle

Or install it yourself as:

    gem install 'rails_utils'

## Usage

### #`page_class`

This helper method returns controller name and action name as a single string value,
which can be used to target CSS styles specifically for this controller or action.

For example, when controller and action is `animes#show`,
you can use `page_class` to include the controller name and action name as CSS classes on the page.

```html+erb
<body class=<%= page_class %>>
  ...
</body>
```

becomes

```html
<body class='animes show'>
  ...
</body>
```

Then in your CSS, you can either target your styles specific to controller and/or action.

```css
body.animes {
  background: black;
}

body.animes.show {
  font-size: 24px;
}
```

Usually, when the `create` or `update` actions render, the `new` or `edit` views will be rendered
due to a form error.

Therefore the `page_class` helper converts `create` to `new` and `update` to `edit`
so that you only need to write CSS to target `new` and `edit`, and not all four actions.

For finer grained control, you can also choose the use the 2 methods that are used to build
`page_class` individually.

The two methods are `page_controller_class` and `page_action_class`.

### #`page_title`

This helper method returns page title based on controller name and action name.

When controller and action is `animes#show` you can easily use `page_title` like:

```html+erb
<div class="page-title">
  <%= page_title %>
</div>
```

becomes

```html
<div class="page-title">
  Animes Show
</div>
```

Besides, it supports I18n and interpolation:

```yaml
en:
  animes:
    show:
      title: Showing anime of: %{anime_name}
```

Pass in `anime_name`:

```html+erb
<div class="page-title">
  <%= page_title(anime_name: "Frozen") %>
</div>
```

becomes

```html
<div class="page-title">
  Showing anime of: Frozen
</div>
```

### #`javascript_initialization`

**You're brwosing rails_utils v4.x, v4.x changes how JavaScript methods are scoped.**

If you're using v3.x, [view latested released v3.x (3.3.6) docs instead](https://github.com/winston/rails_utils/tree/v3.3.6#javascript_initialization).

This helper method attempts to initialize JavaScript classes and methods based on a standard structure.

With this standard structure, calling your JavaScript has never been easier.

Add `javascript_initialization` to the bottom of your layout:

```erb
<%= javascript_initialization %>
```

When application is `MyApp`, and controller/action is `animes#show`, `javascript_initialization`
compiles to:

```html
<script type="text/javascript">
//<![CDATA[
        MyApp.init();
        if(MyApp.animes) {
          if(MyApp.animes.init) { MyApp.animes.init(); }
          if(MyApp.animes.show && MyApp.animes.show.init) { MyApp.animes.show.init(); }
        }
//]]>
</script>
```

By looking at the compiled JavaScript output, it should be apparent on how you should structure
your JavaScript:

```JavaScript
// Sample application.js
window.MyApp = {
  init: function() {
    console.log("Init!")
  }
}
```

As similar to [`page_class`](#page_class), `create` is mapped to `new` and `update` is mapped to `edit`.

### #`flash_messages`

This helper method prints Rails flash messages with classes that correspond to Bootstrap's convention.

Just invoke `flash_messages` anywhere within `layout/application`.

```html+erb
<%= flash_messages %>
```

Suppose there's a `flash[:success]`, you should see:

```html
<div class="alert alert-success fade in">
  <button class="close" data-dismiss-alert="alert" type="button">x</button>
  <p>flash is success</p>
</div>
```

You can also:

- Add additional CSS classes to the alert with the `class` option.
- Customize the close button with `button_html` and `button_class` options.

## Configuration

Override any of these defaults in `config/initializers/rails_utils.rb`:

```ruby
RailsUtils.configure do |config|
  config.selector_format = :underscored # or :hyphenated
end
```

## Contributing

Pull Requests are very welcomed (with specs, of course)!

Minitest-ed. To run all tests, just run `rake` or `rake test`.

## Author

Rails Utils is maintained by [Winston Teo](mailto:winstonyw+rails_utils@gmail.com).

[You should follow Winston on Twitter](https://www.twitter.com/winstonyw), or find out more on [WinstonYW](http://www.winstonyw.com) and [LinkedIn](http://sg.linkedin.com/in/winstonyw).

## License

Copyright © 2013-2016 Winston Teo Yong Wei. Free software, released under the MIT license.


[version-badge]: https://badge.fury.io/rb/rails_utils.svg
[rubygems]: https://rubygems.org/gems/rails_utils
[travis-badge]: https://travis-ci.org/winston/rails_utils.svg
[travis]: https://travis-ci.org/winston/rails_utils
