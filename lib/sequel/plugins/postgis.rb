require 'sequel/plugins/postgis/triggers'
require 'sequel/plugins/postgis/functions'
module Sequel
  module Plugins
    # adds support for postgis specific operations,
    # such as adding/removing geometry columns
    module Postgis
      # note, for organizational purposes, this is broken
      # into many files (required above), that open/reopen
      # the same module

      def self.configure(model, opts={})
      end

      module ClassMethods
        def postgis_extension_loaded?
          true
        end

        def has_column?(col)
          db[table_name].columns.include? col
        end
        
        def _add_update_column
          if !has_column?(:updated_at)
            db.alter_table(self.table_name) do
              add_column :updated_at, DateTime
              add_index :updated_at
            end
          end
	        add_function_update_timestamp
          db["update #{simple_table} set updated_at=now() where updated_at is null"].update
        end

        def add_update_column
          _add_update_column
          add_trigger :update_timestamp
        end
      end

      module InstanceMethods
      end

      module DatasetMethods
      end
    
    end
  end
end
    
