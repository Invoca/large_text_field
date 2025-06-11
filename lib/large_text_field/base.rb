# frozen_string_literal: true

require "invoca/utils"

module LargeTextField
  module Base
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    included do
      validate         :validate_large_text_fields
      before_save      :write_large_text_field_changes
      define_callbacks :large_text_field_save

      class_attribute :large_text_field_options
      self.large_text_field_options = {}

      class_attribute :initialized
      self.initialized = false

      class_attribute :large_text_field_class_name
      self.large_text_field_class_name = "LargeTextField::NamedTextValue"
      class_attribute :large_text_field_class
      self.large_text_field_class = LargeTextField::NamedTextValue

      class_attribute :large_text_field_deprecated_class_name
      self.large_text_field_deprecated_class_name = nil
      class_attribute :large_text_field_deprecated_class
      self.large_text_field_deprecated_class = nil
    end

    def dup
      result = super

      result._clear_text_field_on_dup

      large_text_field_options.each_key { |key| result.set_text_field(key, get_text_field(key)) }

      result
    end

    def reload(options = nil)
      super(options)

      @text_field_hash = nil
      self
    end

    def text_field_hash
      unless @text_field_hash
        @text_field_hash = large_text_fields.build_hash { |text_field| [text_field.field_name, text_field] }
        if large_text_field_deprecated_class_name
          deprecated_large_text_fields.each { |text_field| @text_field_hash[text_field.field_name] ||= text_field }
        end
      end
      @text_field_hash
    end

    def text_field_hash_loaded?
      defined?(@text_field_hash) && @text_field_hash.present?
    end

    def get_text_field(field_name)
      text_field_hash[field_name.to_s]&.value || ''
    end

    def set_text_field(original_field_name, original_value)
      !original_value.nil? or raise "LargeTextField value cannot be set value to nil."

      field_name = original_field_name.to_s
      value = original_value.is_a?(File) ? original_value.read : original_value.to_s
      if (field = text_field_hash[field_name])
        field.value = value
      else
        text_field_hash[field_name] = large_text_field_class.new(owner: self, field_name:, value:)
      end
    end

    def text_field_changed(field_name)
      text_field_hash_loaded? && @text_field_hash[field_name]&.changes&.any?
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def validate_large_text_fields
      if text_field_hash_loaded?
        large_text_field_options.each do |key, options|
          value = text_field_hash[key]&.value
          conjugation = options[:singularize_errors] ? "is" : "are"
          maximum = options[:maximum] || MAX_LENGTH

          if value.present? && value.size > maximum
            errors.add(
              key,
              "#{conjugation} too long (maximum is #{self.class.formatted_integer_value(maximum)} characters)"
            )
          end
        end
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def write_large_text_field_changes
      run_callbacks(:large_text_field_save)

      @text_field_hash = text_field_hash
                         .compact
                         .select { |_key, value| value.value.presence }
                         .transform_values { |value| value.is_a?(large_text_field_class) ? value : large_text_field_class.new(owner: self, field_name: value.field_name, value: value.value) }
      self.large_text_fields = text_field_hash.values.compact
      true
    end

    def _clear_text_field_on_dup
      if instance_variable_defined?(:@text_field_hash)
        remove_instance_variable(:@text_field_hash)
      end
    end

    module ClassMethods
      def large_text_field_class_name_override(value)
        self.large_text_field_class_name = value
        self.large_text_field_class = Object.const_get(value)
      end

      def large_text_field_deprecated_class_name_override(value)
        self.large_text_field_deprecated_class_name = value
        self.large_text_field_deprecated_class = Object.const_get(value)
      end

      def initialize_large_text_field
        return if initialized # skip if already initialized

        has_many(
          :large_text_fields,
          class_name: large_text_field_class_name,
          as: :owner,
          autosave: true,
          dependent: :destroy,
          inverse_of: :owner
        )
        if large_text_field_deprecated_class_name
          has_many(
            :deprecated_large_text_fields,
            class_name: large_text_field_deprecated_class_name,
            as: :owner,
            autosave: true,
            dependent: :destroy,
            inverse_of: :owner
          )
        end
        self.initialized = true
      end

      def large_text_field(field_name, maximum: nil, singularize_errors: false)
        initialize_large_text_field # ensure the association is initialized

        field_name = field_name.to_s

        # validate custom maximum
        if maximum
          if !maximum.is_a? Integer
            raise ArgumentError, "maximum must be a number"
          elsif maximum > MAX_LENGTH
            raise ArgumentError, "maximum can't be greater than #{formatted_integer_value(MAX_LENGTH)}"
          elsif maximum.negative?
            raise ArgumentError, "maximum can't be less than 0"
          end
        end

        large_text_field_options[field_name] = { maximum:, singularize_errors: }
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
