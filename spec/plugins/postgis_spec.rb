require "spec_helper"

describe "add helper methods to Sequel::Model" do
  before do
    @db = Sequel.connect('mock://postgres', :quote_identifiers=>false)
    Sequel::Model.plugin :postgis
  end
  it "will add an automatic updated_at column to itself" do
    @db.create_table(:dummy){String :name; geometry :the_geom}
    @db.indexes(:dummy).should be_empty
    @model = Class.new(Sequel::Model(:dummy))
    @db.sqls.should_not include('ALTER TABLE dummy ADD COLUMN updated_at timestamp')
    @model._add_update_column
    @db.sqls.should include ['ALTER TABLE dummy ADD COLUMN updated_at timestamp', 
                            'CREATE INDEX dummy_updated_at_index ON dummy (updated_at)']
    @model.add_trigger :update_timestamp
    @db.sqls.should include ('CREATE TRIGGER update_timestamp BEFORE INSERT OR UPDATE ON dummy FOR EACH ROW EXECUTE PROCEDURE update_timestamp()')
    
    
  end
  it "when adding an automatic updated_at column it will only add the trigger if one exists" do
    @db.create_table(:dummy){String :name; geometry :the_geom; DateTime :updated_at}
    @db.indexes(:dummy).should be_empty
    @model = Class.new(Sequel::Model(:dummy))
    @db.sqls.should_not include('CREATE TRIGGER update_timestamp BEFORE INSERT OR UPDATE ON dummy FOR EACH ROW EXECUTE PROCEDURE update_timestamp()')
    @model.add_update_column
    pp @db.sqls
    @db.sqls.should include('CREATE TRIGGER update_timestamp BEFORE INSERT OR UPDATE ON dummy FOR EACH ROW EXECUTE PROCEDURE update_timestamp()')
  end
end

