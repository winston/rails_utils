require 'test_helper'

describe "RailsUtils::ActionViewExtensions" do
  let(:controller)  { ActionController::Base.new }
  let(:request)     { ActionDispatch::Request.new(flash: {}) }
  let(:view)        { ActionView::Base.new }

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

    describe "simple controller" do
      let(:controller_class) { "Awesome::AnimeController" }
      let(:controller_name)  { "awesome_anime" }

      before { controller.stubs(:class).returns(controller_class) }

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
    let(:action_name)     { "custom" }
    let(:default_translation) { "#{controller_name.capitalize} #{action_name.capitalize}" }

    before do
      view.stubs(:page_controller_class).returns(controller_name)
      view.stubs(:page_action_class).returns(action_name)
    end

    it 'generates translation' do
      I18n.expects(:t).with('.title', default: default_translation)
      view.page_title
    end

    describe 'when translation is missing' do
      it "combines page_controller_class and page_action_class" do
        view.page_title.must_equal default_translation
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
      let(:action_name)     { "custom" }

      it "invokes application" do
        view.javascript_initialization.must_match "Dummy.init();"
      end

      it "invokes controller and action javascript" do
        view.javascript_initialization.must_match "Dummy.#{controller_name}.init();"
        view.javascript_initialization.must_match "Dummy.#{controller_name}.init_#{action_name}();"
      end
    end

    describe "when action name is create" do
      let(:action_name)     { "create" }

      it "replaces create with new" do
        view.javascript_initialization.must_match "Dummy.#{controller_name}.init_new();"
      end
    end

    describe "when action name is update" do
      let(:action_name)     { "update" }

      it "replaces update with create" do
        view.javascript_initialization.must_match "Dummy.#{controller_name}.init_edit();"
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
      [ :notice  , /alert alert-info/               , "flash is notice"  ],
      [ "notice" , /alert alert-info/               , "flash is notice"  ],
      [ :error   , /alert alert-danger alert-error/ , "flash is error"   ],
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
        set_flash :alert  , "not important"
        view.flash_messages.must_match /fade in/
      end

      it "can be dismissed" do
        set_flash :alert  , "not important"
        view.flash_messages.must_match /data-dismiss=.*alert/
      end
    end
  end
end
