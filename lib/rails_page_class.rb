require 'action_view'

module RailsPageClass
  module ActionViewExtensions
    def page_class
      "#{page_controller_class} #{page_action_class}"
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
