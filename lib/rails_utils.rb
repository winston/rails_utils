require 'action_view'

module RailsUtils
  module ActionViewExtensions
    def page_controller_class
      cssize(controller.class.to_s.sub(/Controller$/, ""))
    end

    def page_action_class
      class_mappings = { "create" => "new", "update" => "edit" }
      result = class_mappings.fetch(controller.action_name, nil)
      if defined?(HighVoltage) && controller.is_a?(HighVoltage::PagesController)
        result ||= controller.current_page
      end
      result ||= controller.action_name
      cssize(result)
    end

    def page_class
      "#{page_controller_class} #{page_action_class}"
    end

    def page_title(options={})
      default_page_title = "#{page_controller_class.capitalize} #{page_action_class.capitalize}"
      i18n_options = { default: default_page_title }.merge!(options)
      I18n.t("#{page_controller_class}.#{page_action_class}.title", i18n_options)
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

    def flash_messages(options = {})
      flash.collect do |key, message|
        next if message.blank?
        next if key.to_s == 'timedout'

        content_tag(:div, content_tag(:button, options[:button_html] || "x", type: "button", class: options[:button_class] || "close", "data-dismiss" => "alert") + message, class: "#{flash_class(key)} fade in #{options[:class]}")
      end.join("\n").html_safe
    end

    private

    def cssize(identifier)
      identifier.underscore.sub(/\//, "_")
    end

    def flash_class(key)
      case key.to_sym
        when :success
          "alert alert-success"
        when :notice
          "alert alert-info"
        when :error
          "alert alert-danger alert-error"
        when :alert
          "alert alert-danger alert-error"
        else
          "alert alert-#{key}"
      end
    end
  end
end

ActionView::Base.send :include, RailsUtils::ActionViewExtensions
