require 'action_view'

module RailsPageClass
  module ActionViewExtensions
    def page_class
      "#{page_controller_class} #{page_action_class}"
    end

    def javascript_initialization
      application_name = Rails.application.class.parent_name

      javascript_tag <<-JS
        #{application_name}.init();
        if(#{application_name}.#{page_controller_class}) {
          if(#{application_name}.#{page_controller_class}.init) { #{application_name}.#{page_controller_class}.init(); }
          if(#{application_name}.#{page_controller_class}.init_#{page_action_class}) { #{application_name}.#{page_controller_class}.init_#{page_action_class}(); }
        }
      JS
    end

    private

    def page_controller_class
      controller.controller_name
    end

    def page_action_class
      class_mappings = { "create" => "new", "update" => "edit" }
      class_mappings[controller.action_name] || controller.action_name
    end
  end
end


ActionView::Base.send :include, RailsPageClass::ActionViewExtensions
