require "spec_helper"

describe "PostGIS extensions to Sequel" do
  before do
    @db = Sequel.connect('mock://postgres', :quote_identifiers=>false)
    Sequel::Model.plugin :postgis
  end
  
  it "will populate geometry columns with a single command" do
    @db.extension(:postgis)
    @db.create_table(:dummy){String :name; geometry :the_geom}
    @db.indexes(:dummy).should be_empty
    @db.populate_geometry_columns
    @db.sqls.should include ('SELECT Populate_Geometry_Columns()')
  end
      
end 