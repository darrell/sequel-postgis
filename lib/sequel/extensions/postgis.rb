require 'sequel/plugins/postgis/triggers'
require 'sequel/plugins/postgis/functions'
module Sequel
  module Postgis
    # note, for organizational purposes, this is broken
    # into many files (required above), that open/reopen
    # the same module

    def self.configure(model, opts={})
    end

    module DatabaseMethods
      def populate_geometry_columns(options={})
        run %Q/SELECT Populate_Geometry_Columns()/
      end
      def doit
        raise "foo"
      end
    end
  end
  Database.register_extension(:postgis, Postgis::DatabaseMethods)
end
    
