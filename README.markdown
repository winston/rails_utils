# Rails Page Class

This gem provides a Rails helper method that returns controller name and action name as a single string value.

This can be used to target CSS styles specifically at this controller or action.

For example, when controller and action is `anime#show`, 
you can use `page_class` to include the controller name and action name as CSS classes on the page.

    %body{ class: page_class }
    
becomes 

    <body class='anime show'>
    
Then in your CSS, you can either target your styles specific to controller and/or action.

    body.anime
      background: black
    
    body.anime.show
      font-size: 24px

Usually, when the `create` or `update` actions render, the `new` or `edit` views will be rendered due to a form error.

Therefore the `page_class` helper converts `create` to `new` and `update` to `edit`
so that you only need to write CSS to target `new` and `edit`, and not all four actions.

## Installation

    gem install rails_page_class

## Testing

Minitest-ed. To run all tests, just run `rake` or `rake test`.

## Author

Rails Page Class is maintained by [Winston Teo](mailto:winstonyw+googlevisualr@gmail.com).

Who is Winston Teo? [You should follow Winston on Twitter](http://www.twitter.com/winstonyw), or find out more on [WinstonYW](http://www.winstonyw.com) and [LinkedIn](http://sg.linkedin.com/in/winstonyw).


## License

Copyright © 2012 Winston Teo Yong Wei. Free software, released under the MIT license.
