# TODO - this should be moved to our junk drawer gem. (Inovca utils?)
module LargeTextField
  module RealReload
    def reload(options = nil)
      clear_extra_instance_variables
      super
    end

    private
    def clear_extra_instance_variables
      instance_variables.each do |var|
        send(:remove_instance_variable, var) unless var.in? [:@aggregation_cache, :@association_cache, :@attributes, :@attributes_cache, :@changed_attributes, :@destroyed, :@marked_for_destruction, :@new_record, :@previously_changed, :@readonly]
      end
    end
  end
end

