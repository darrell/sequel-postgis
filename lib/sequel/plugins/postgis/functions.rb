module Sequel
  module Plugins
    module Postgis
      module ClassMethods
          # checks to see if database function of the supplied name exists
          def has_function?(name)
            self.db[:pg_proc].first(:proname => name.to_s).nil? ? false : true
          end

          # wrapper method for adding functions
          # takes function name as a symbol
          # must have associated method
          def add_function(name)
            case name
            when :update_timestamp
              return add_function_update_timestamp
            end
            raise "called add_function on undefined function '#{name}'"
          end


          private
          ####
          # Functions for add_function
          #
          ### 

          # create the update_timestamp function in the database
          # add :force => true to force overwriting an
          # existing function
          def add_function_update_timestamp(opts={})
            if has_function?(:update_timestamp)
              # if we have it, overwrite it if force is set
              if !opts[:force] 
                return true 
              end
            end
            func=%Q{
              BEGIN
                NEW.updated_at := now();
                RETURN NEW;
              END;
            }
            self.db.create_function :update_timsestamp, func, :replace => true, :returns => 'trigger', :language => 'plpgsql'
          end
        end
    end
  end
end
