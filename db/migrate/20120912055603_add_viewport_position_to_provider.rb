class AddViewportPositionToProvider < ActiveRecord::Migration
  def self.up
    add_column :providers, :viewport_center, :point
    add_column :providers, :viewport_zoom, :integer
  end

  def self.dowe
    remove_column :providers, :viewport_center
    remove_column :providers, :viewport_zoom
  end
end
