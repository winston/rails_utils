# frozen_string_literal: true

require "rails_utils/configuration"
require "action_view"

module RailsUtils
  module ActionViewExtensions
    def page_controller_class
      case RailsUtils.configuration.selector_format.to_sym
      when :hyphenated
        page_controller_class_hyphenated
      else # :underscored
        page_controller_class_underscored
      end
    end

    def page_action_class
      class_mappings = { "create" => "new", "update" => "edit" }
      class_mappings[controller.action_name] || controller.action_name
    end

    def page_class
      "#{page_controller_class} #{page_action_class}"
    end

    def page_title(options={})
      @page_title ||= begin
        default_page_title = "#{page_controller_class.capitalize} #{page_action_class.capitalize}"
        i18n_options = { default: default_page_title }.merge!(options)
        I18n.t("#{page_controller_class}.#{page_action_class}.title", i18n_options)
      end
    end

    def javascript_initialization(options = {})
      application_name  = Rails.application.class.parent_name
      js_namespace_name = page_controller_class_underscored
      js_function_name  = page_action_class

      if content_for?(:js_init_method)
        js_custom_name = content_for(:js_init_method)
        custom_js_init_method = "if(#{application_name}.#{js_namespace_name}.#{js_custom_name}.init) { #{application_name}.#{js_namespace_name}.#{js_custom_name}.init(); }"
      end

      javascript_tag <<-JS
        #{application_name}.init();
        if(#{application_name}.#{js_namespace_name}) {
          if(#{application_name}.#{js_namespace_name}.init) { #{application_name}.#{js_namespace_name}.init(); }
          if(#{application_name}.#{js_namespace_name}.#{js_function_name} && #{application_name}.#{js_namespace_name}.#{js_function_name}.init) { #{application_name}.#{js_namespace_name}.#{js_function_name}.init(); }
          #{custom_js_init_method}
        }
      JS
    end

    def flash_messages(options = {})
      flash.collect do |key, message|
        next if message.blank?
        next if key.to_s == "timedout"

        content_tag(:div, content_tag(:button, options[:button_html] || "x", type: "button", class: options[:button_class] || "close", "data-dismiss" => "alert") + message.html_safe, class: "#{flash_class(key)} fade in #{options[:class]}")
      end.join("\n").html_safe
    end

    private

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

      def page_controller_class_hyphenated
        page_controller_class_underscored.dasherize
      end

      def page_controller_class_underscored
        controller.class.to_s.sub(/Controller$/, "").underscore.gsub(/\//, "_")
      end
  end
end

ActionView::Base.send :include, RailsUtils::ActionViewExtensions
