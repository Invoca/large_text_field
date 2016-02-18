module LargeTextField
  module ClonePatch
    extend ActiveSupport::Concern

    # Not sure how this is going to work.
    alias :unsafe_clone :clone
    alias :unsafe_dup :dup

    # Rails 3.2 renamed clone to dup, leaving the Ruby clone behavior (which shallow copies everything)
    def clone
      raise "ApplicationModel#clone has been deprecated in favor of copy(:new_record => true) to help disambiguate the confusion around `dup`, `clone` and Rails. clone has been called by:\n#{'*' * 20}\n#{caller.join("\n")}:#{"this doesn't quite work"; $<.file.lineno}\n#{'*' * 20}\n"
    end

    def dup
      raise "ApplicationModel#dup has been deprecated in favor of copy(:new_record => false) to help disambiguate the confusion around `dup`, `clone`, and Rails.  dup has been called by:\n#{'*' * 20} \n#{caller.join("\n")}:#{$<.file.lineno}\n#{'*' * 20}\n"
    end

    def copy(opts = {})
      if opts[:new_record]
        result =
          if defined?(super)
            super(opts)
          else
            unsafe_dup
          end
        result.changed_attributes.clear
        result.clear_extra_instance_variables
        result
      else
        unsafe_clone
      end
    end
  end
end
