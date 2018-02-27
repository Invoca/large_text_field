module LargeTextField
  module Owner
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      has_many         :large_text_fields, class_name: "LargeTextField::NamedTextValue", as: :owner, autosave: true, dependent: :destroy, inverse_of: :owner
      validate         :validate_large_text_fields
      before_save      :write_large_text_field_changes
      define_callbacks :large_text_field_save

      class_attribute :large_text_field_options
      self.large_text_field_options = {}
    end

    def dup
      result = super

      result._clear_text_field_on_dup

      large_text_field_options.keys.each { |k| result.set_text_field(k, get_text_field(k)) }

      result
    end

    def reload
      super
      @text_field_hash = nil
      self
    end

    def text_field_hash
      @text_field_hash ||= large_text_fields.build_hash { |text_field| [text_field.field_name, text_field] }
    end

    def text_field_hash_loaded?
      defined?(@text_field_hash) && @text_field_hash.present?
    end

    def get_text_field(field_name)
      text_field_hash[field_name.to_s]._?.value || ''
    end

    def set_text_field(original_field_name, original_value)
      !original_value.nil? or raise "LargeTextField value cannot be set value to nil."

      field_name = original_field_name.to_s
      value = original_value.is_a?(File) ? original_value.read : original_value.to_s
      if (field = text_field_hash[field_name])
        field.value = value
      else
        text_field_hash[field_name] = LargeTextField::NamedTextValue.new(owner: self, field_name: field_name, value: value)
      end
    end

    def text_field_changed(field_name)
      text_field_hash_loaded? && @text_field_hash[field_name]._?.changes._?.any?
    end

    def validate_large_text_fields
      if text_field_hash_loaded?
        large_text_field_options.each do |k, options|
          value = text_field_hash[k]._?.value
          conjugation = options[:singularize_errors] ? "is" : "are"
          maximum = options[:maximum] || MAX_LENGTH
          errors.add k, "#{conjugation} too long (maximum is #{self.class.formatted_integer_value(maximum)} characters)" if value.present? && value.size > maximum
        end
      end
    end

    def write_large_text_field_changes
      run_callbacks(:large_text_field_save)

      @text_field_hash = text_field_hash.compact.select { |_k, v| v.value.presence }
      self.large_text_fields = text_field_hash.values.compact
      true
    end

    def _clear_text_field_on_dup
      if instance_variable_defined?(:@text_field_hash)
        remove_instance_variable(:@text_field_hash)
      end
    end

    module ClassMethods
      def large_text_field(field_name, maximum: nil, singularize_errors: false)
        field_name = field_name.to_s

        # validate custom maximum
        if maximum
          if !maximum.is_a? Integer
            raise ArgumentError, "maximum must be a number"
          elsif maximum > MAX_LENGTH
            raise ArgumentError, "maximum can't be greater than #{formatted_integer_value(MAX_LENGTH)}"
          elsif maximum < 0
            raise ArgumentError, "maximum can't be less than 0"
          end
        end

        large_text_field_options[field_name] = { maximum: maximum, singularize_errors: singularize_errors }
        define_method(field_name)              {         get_text_field(field_name)        }
        define_method("#{field_name}=")        { |value| set_text_field(field_name, value) }
        define_method("#{field_name}_changed?") { text_field_changed(field_name) }
      end

      def formatted_integer_value(value)
        value.to_i.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
      end
    end
  end
end
