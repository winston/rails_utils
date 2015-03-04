# Rails Utils

[![Build Status](https://travis-ci.org/winston/rails_utils.png?branch=master)](https://travis-ci.org/winston/rails_utils)

Rails helpers based on opinionated project practices. Currently useful for structuring CSS and JS.

## Installation

    gem install 'rails_utils'


## #`page_class`

This helper method returns controller name and action name as a single string value,
which can be used to target CSS styles specifically for this controller or action.

For example, when controller and action is `animes#show`,
you can use `page_class` to include the controller name and action name as CSS classes on the page.

    %body{ class: page_class }

becomes

    <body class='animes show'>

Then in your CSS, you can either target your styles specific to controller and/or action.

    body.animes
      background: black

    body.animes.show
      font-size: 24px

Usually, when the `create` or `update` actions render, the `new` or `edit` views will be rendered due to a form error.

Therefore the `page_class` helper converts `create` to `new` and `update` to `edit`
so that you only need to write CSS to target `new` and `edit`, and not all four actions.

For finer grained control, you can also choose the use the 2 methods that are used to build `page_class` individually.
The two methods are `page_controller_class` and `page_action_class`.

## #`page_title`

This helper method returns page title based on controller name and action name.

When controller and action is `animes#show`
you can easily use `page_title` like

    .page-title= page_title

becomes

    <div class='page-title'>Animes Show</div>

Besides, it supports I18n and interpolation:

    en:
      animes:
        show:
          title: Showing anime of: %{anime_name}

    .page-title= page_title(anime_name: 'Frozen')

becomes

    <div class='page-title'>Showing anime of: Frozen</div>

## #`javascript_initialization`

This helper method attempts to initialize JavaScript classes and methods based on a standard structure.

With this standard structure, calling your JavaScript has never been easier.

Add `javascript_initialization` to the bottom of your layout.

    = javascript_initialization

When application is MyApp, and controller/action is `animes#show`, `javascript_initialization` compiles to:

    <script type="text/javascript">
    //<![CDATA[
            MyApp.init();
            if(MyApp.animes) {
              if(MyApp.animes.init) { MyApp.animes.init(); }
              if(MyApp.animes.init_show) { MyApp.animes.init_show(); }
            }
    //]]>
    </script>

By looking at the compiled JavaScript output, it should be apparent on how you should structure your JavaScript.

As similar to `page_class`, `create` is mapped to `new` and `update` is mapped to `edit`.

    // Sample CoffeeScript to get you started
    window.MyApplication =
      init: ->
        console.log("Init!")

## #`flash_messages`

This helper method prints Rails flash messages with classes that correspond to Bootstrap's convention.

Just invoke `flash_messages` anywhere within `layout/application`.

    = flash_messages

Suppose there's a `flash[:success]`, you should see:

    <div class="alert alert-success fade in">
      <button class="close" data-dismiss-alert="alert" type="button">x</button>
      <p>flash is success</p>
    </div>

You can also:

- Add additional CSS classes to the alert with the `class` option.
- Customize the close button with `button_html` and `button_class` options.

## Configuration

Override any of these defaults in `config/initializers/rails_utils.rb`

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

Copyright © 2014 Winston Teo Yong Wei. Free software, released under the MIT license.
