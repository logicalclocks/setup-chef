module Setup 
  module Helpers

    def recursiveFlat(m)
        values = m.values
        ret_value = []
        values.each do |v|
            if v.instance_of? Hash
            ret_value << recursiveFlat(v)
            else
            ret_value << v
            end
        end
        ret_value
    end

  end
end