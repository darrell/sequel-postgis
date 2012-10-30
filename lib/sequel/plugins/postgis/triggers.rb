# wrapper method for adding triggers
# takes trigger name as a symbol,
# must have associated method
module Sequel
  module Plugins
    module Postgis
      module ClassMethods
          # add a trigger of the defined name.
          # should have an associated private method, this is not (yet) a generic interface
          # for adding triggers
          # returns true and does not execute any SQL if a trigger of that name already exists
          # use has_trigger?(:trigger_name) to test if one is defined
          def add_trigger(name)
            return true if has_trigger?(name)
            self.send("add_trigger_#{name}")
          end

          # Does my table have a given trigger defined?
          def has_trigger?(name)
            q=db.from(:pg_class).join(:pg_trigger, :tgrelid => :oid).where(:relname => Sequel.split_symbol(self.table_name)[1], :tgname => name.to_s)
            q.first.nil? ? false : true
          end

          private
          ####
          # Triggers for add_trigger
          #
          ###
        
          # add trigger definition to this table
          def add_trigger_update_timestamp
            self.db.create_trigger self.table_name, 'update_timestamp', 'update_timestamp', :events => [:insert, :update], :each_row => true
            true
          end
        end        
    end
  end
end
