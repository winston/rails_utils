require 'test_helper'

describe "RailsPageClass::ActionViewExtensions" do

  let(:controller)  { ActionController::Base.new }
  let(:view)        { ActionView::Base.new }

  before { view.controller = controller }

  # controller_name, action_name, expected
  [
    [ "anime", "index"  , "anime index"   ],
    [ "anime", "show"   , "anime show"    ],
    [ "anime", "new"    , "anime new"     ],
    [ "anime", "create" , "anime new"     ],
    [ "anime", "edit"   , "anime edit"    ],
    [ "anime", "update" , "anime edit"    ],
    [ "anime", "destroy", "anime destroy" ],
    [ "anime", "custom" , "anime custom"  ],
  ].each do |controller_name, action_name, expected|
    describe "when #{controller_name} and #{action_name}" do
      before do
        controller.stubs(:controller_name).returns(controller_name)
        controller.stubs(:action_name).returns(action_name)
      end

      it "returns #{expected}" do
         view.page_class.must_equal expected
      end
    end
  end

end
