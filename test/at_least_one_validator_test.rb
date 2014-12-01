require 'test_helper'

describe "RailsUtils::Validators" do

  class Photo < ActiveRecord::Base; end
  class Album < ActiveRecord::Base
    has_many :photos
    validates :photos, at_least_one: true
  end

  before(:all) do
    ActiveRecord::Base.connection.create_table "albums", force: true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    ActiveRecord::Base.connection.create_table "photos", force: true do |t|
      t.integer  "album_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  describe '#at_least_one' do
    it 'should require at least 1 valid child' do
      album = Album.new
      assert_includes album.tap(&:valid?).errors.keys, :photos
      album.photos << Photo.new
      refute_includes album.tap(&:valid?).errors.keys, :photos
    end

    it 'cannot delete the last child' do
      album = Album.new(photos: [Photo.new])
      refute_includes album.tap(&:valid?).errors.keys, :photos
      album.photos.first.mark_for_destruction
      assert_includes album.tap(&:valid?).errors.keys, :photos
    end
  end
end
