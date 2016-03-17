require 'test_helper'

describe "RailsUtils::ActionViewExtensions" do
  let(:controller) { ActionController::Base.new }
  let(:request)    { ActionDispatch::Request.new(flash: {}) }
  let(:view)       { ActionView::Base.new }

  before do
    controller.request = request
    view.controller    = controller
  end

  describe "#page_controller_class" do
    describe "simple controller" do
      let(:controller_class) { "AnimeController" }
      let(:controller_name)  { "anime" }

      before { controller.stubs(:class).returns(controller_class) }

      it "returns controller name" do
        view.page_controller_class.must_equal controller_name
      end
    end

    describe "nested controller returns underscored name by default" do
      let(:controller_class) { "Super::Awesome::AnimeController" }
      let(:controller_name)  { "super_awesome_anime" }

      before { controller.stubs(:class).returns(controller_class) }

      it "returns controller name" do
        view.page_controller_class.must_equal controller_name
      end
    end

    describe "nested controller with selector format returns hyphenated name" do
      let(:controller_class) { "Super::Awesome::AnimeController" }
      let(:controller_name)  { "super-awesome-anime" }

      before do
        RailsUtils.configure do |config|
          config.selector_format = :hyphenated
        end

        controller.stubs(:class).returns(controller_class)
      end

      it "returns controller name" do
        view.page_controller_class.must_equal controller_name
      end
    end

    describe "nested controller with selector format of string returns name in specified format" do
      let(:controller_class) { "Super::Awesome::AnimeController" }
      let(:controller_name)  { "super_awesome_anime" }

      before do
        RailsUtils.configure do |config|
          config.selector_format = "underscored"
        end

        controller.stubs(:class).returns(controller_class)
      end

      it "returns controller name" do
        view.page_controller_class.must_equal controller_name
      end
    end
  end

  describe "#page_action_class" do
    # action_name, expected
    [
      [ "index"  , "index"   ],
      [ "show"   , "show"    ],
      [ "new"    , "new"     ],
      [ "create" , "new"     ],
      [ "edit"   , "edit"    ],
      [ "update" , "edit"    ],
      [ "destroy", "destroy" ],
      [ "custom" , "custom"  ],
    ].each do |action_name, expected|
      describe "when ##{action_name}" do
        before { controller.stubs(:action_name).returns(action_name) }

        it "returns #{expected}" do
          view.page_action_class.must_equal expected
        end
      end
    end
  end

  describe "#page_class" do
    let(:controller_name) { "anime" }
    let(:action_name)     { "custom" }

    before do
      view.stubs(:page_controller_class).returns(controller_name)
      view.stubs(:page_action_class).returns(action_name)
    end

    it "uses page_controller_class and page_action_class" do
      view.page_class.must_equal "#{controller_name} #{action_name}"
    end
  end

  describe "#page_title" do
    let(:controller_name) { "anime" }

    before do
      view.stubs(:page_controller_class).returns(controller_name)
      view.stubs(:page_action_class).returns(action_name)
    end

    describe 'when translation is missing' do
      let(:action_name)  { "random" }
      let(:default_translation) { "#{controller_name.capitalize} #{action_name.capitalize}" }

      it "combines page_controller_class and page_action_class" do
        view.page_title.must_equal default_translation
      end

      it "uses :default provided by gem user" do
        view.page_title(default: 'my custom default').must_equal 'my custom default'
      end

      it "calling multiple times reuses first result (template renders before layout)" do
        view.page_title(default: 'my custom default').must_equal 'my custom default'
        view.page_title.must_equal 'my custom default'
      end
    end

    describe 'when translation is available' do
      let(:action_name) { "show" }

      before { I18n.backend.store_translations("en", { controller_name.to_sym => { action_name.to_sym => { title: "An awesome title" } }}) }

      it "translates page title" do
        view.page_title.must_equal "An awesome title"
      end
    end

    describe "when translation is available + interpolations" do
      let(:action_name) { "show" }

      before { I18n.backend.store_translations("en", { controller_name.to_sym => { action_name.to_sym => { title: "An awesome title, %{name}" } }}) }

      it "translates page title" do
        view.page_title(name: "bro").must_equal "An awesome title, bro"
      end
    end
  end

  describe "#javascript_initialization" do
    let(:controller_class) { "Awesome::AnimeController" }
    let(:controller_name)  { "awesome_anime" }

    before do
      controller.stubs(:class).returns(controller_class)
      controller.stubs(:action_name).returns(action_name)
    end

    describe "when controller name and action name are standard" do
      let(:action_name) { "custom" }

      it "invokes application" do
        view.javascript_initialization.must_match "Dummy.init();"
      end

      it "invokes controller and action javascript" do
        view.javascript_initialization.must_match "Dummy.#{controller_name}.init();"
        view.javascript_initialization.must_match "Dummy.#{controller_name}.#{action_name}.init();"
      end
    end

    describe "when action name is create" do
      let(:action_name) { "create" }

      it "replaces create with new" do
        view.javascript_initialization.must_match "Dummy.#{controller_name}.new.init();"
      end
    end

    describe "when action name is update" do
      let(:action_name) { "update" }

      it "replaces update with create" do
        view.javascript_initialization.must_match "Dummy.#{controller_name}.edit.init();"
      end
    end

    describe "with a content_for custom js_init_method as an argument" do
      let(:action_name) { "update" }

      it "uses the custom js init method" do
        view.content_for(:js_init_method) { "custom" }
        view.javascript_initialization.must_match "Dummy.#{controller_name}.custom.init();"
      end
    end

    describe "without a content_for custom js_init_method as an argument" do
      let(:action_name) { "update" }

      it "does not generate an additional javascript method" do
        view.javascript_initialization.wont_match "Dummy.#{controller_name}..init();"
      end
    end
  end

  describe "#flash_messages" do
    def set_flash(key, message)
      controller.flash[key] = message
    end

    # TODO: Remove support for Bootstrap v2.3.2
    # alert-danger is for Bootstrap 3
    # alert-error  is for Bootstrap 2.3.2
    [
      [ :success , /alert alert-success/            , "flash is success" ],
      [ "success", /alert alert-success/            , "flash is success" ],
      [ :notice  , /alert alert-info/               , "flash is notice"  ],
      [ "notice" , /alert alert-info/               , "flash is notice"  ],
      [ :error   , /alert alert-danger alert-error/ , "flash is error"   ],
      [ "error"  , /alert alert-danger alert-error/ , "flash is error"   ],
      [ :alert   , /alert alert-danger alert-error/ , "flash is alert"   ],
      [ "alert"  , /alert alert-danger alert-error/ , "flash is alert"   ],
      [ :custom  , /alert alert-custom/             , "flash is custom"  ],
      [ "custom" , /alert alert-custom/             , "flash is custom"  ]
    ].each do |key, expected_class, expected_message|
      describe "when flash contains #{key} key" do
        before { set_flash key, expected_message }

        it "prints class '#{expected_class}'" do
          view.flash_messages.must_match expected_class
        end

        it "prints message '#{expected_message}'" do
          view.flash_messages.must_match expected_message
        end
      end
    end

    describe "when bootstrap is present" do
      it "can fade in and out" do
        set_flash :alert, "not important"
        view.flash_messages.must_match /fade in/
      end

      it "can be dismissed" do
        set_flash :alert, "not important"
        view.flash_messages.must_match /data-dismiss=.*alert/
      end
    end

    describe "options" do
      it "can allow override of button content (default 'x')" do
        set_flash :alert, "not important"
        view.flash_messages.must_match %r{>x</button>}
        view.flash_messages(button_html: '').must_match %r{button class="close"}
      end

      it "can allow override of button css class (default 'close')" do
        set_flash :alert, "not important"
        view.flash_messages.must_match %r{>x</button>}
        view.flash_messages(button_class: 'abc def').must_match %r{button class="abc def"}
      end
    end

    it "should skip flash[:timedout]" do
      set_flash :timedout, "not important"
      view.flash_messages.must_equal ""
    end

    it "should be `html_safe`ed" do
      set_flash :alert, "not important"

      view.flash_messages.html_safe?.must_equal true
    end

    it "each message of flash should call html_safe" do
      set_flash :alert, Minitest::Mock.new

      messages = view.flash.instance_variable_get(:@flashes).values.each do |message|
        message.expect :blank?, false
        message.expect :html_safe, "test"
        message.expect :html_safe?, true
      end

      view.flash_messages.must_equal "<div class=\"alert alert-danger alert-error fade in \"><button class=\"close\" data-dismiss=\"alert\" type=\"button\">x</button>test</div>"
    end
  end
end
