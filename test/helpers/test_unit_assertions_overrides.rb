require 'mail'
# Move to invoca-rails-utils
module Test
  module Unit
    module Assertions
      def assert_raises(klass, regex_or_msg = nil, &block)
        assert_raise(klass, regex_or_msg, &block)
      end

      def assert_raise(*args, &block)
        assert_raise_with_regex(*args, &block)
      end

      def assert_raise_with_regex(klass, message = nil, regex = nil, &block)
        if message.is_a?(Regexp)
          regex, message = message, regex
        end
        message ||= ""
        actual_exception = original_raise(klass, message, &block)
        if regex
          assert_match regex, actual_exception.to_s, message
        end
        actual_exception
      end

      def original_raise(*args, &block)
        assert_expected_exception = Proc.new do |*_args|
          message, assert_exception_helper, actual_exception = _args
          expected = assert_exception_helper.expected_exceptions
          diff = AssertionMessage.delayed_diff(expected, actual_exception)

          full_message = build_message(message,
                                       "<?> exception expected but was\n<?>.?",
                                       expected, actual_exception, diff)
          begin
            assert_block(full_message) do
              expected == [] or
                assert_exception_helper.expected?(actual_exception)
            end
          rescue AssertionFailedError => failure
            _set_failed_information(failure, expected, actual_exception,
                                    message)
            raise failure # For JRuby. :<
          end
        end

        _assert_raise(assert_expected_exception, *args, &block)
      end

      def assert(object=NOT_SPECIFIED, message=nil, &block)
        msg = if Array === message
                message.join
              elsif Symbol === message
                message.to_s
              elsif Mail::Body === message
                message.to_s
              elsif Fixnum === message
                message.to_s
              elsif nil === message
                message
              elsif String === message
                message
              elsif Proc === message
                message.to_s
              end
        original_assert(object, msg, &block)
      end

      def original_assert(object=NOT_SPECIFIED, message=nil, &block)
        _wrap_assertion do
          have_object = !NOT_SPECIFIED.equal?(object)
          if block
            message = object if have_object
            if defined?(PowerAssert)
              PowerAssert.start(block, :assertion_method => __callee__) do |pa|
                pa_message = AssertionMessage.delayed_literal(&pa.message_proc)
                assertion_message = build_message(message, "?", pa_message)
                assert_block(assertion_message) do
                  pa.yield
                end
              end
            else
              assert(yield, message)
            end
          else
            unless have_object
              raise ArgumentError, "wrong number of arguments (0 for 1..2)"
            end
            assertion_message = nil
            case message
            when nil, String, Proc
            when AssertionMessage
              assertion_message = message
            else
              error_message = "assertion message must be String, Proc or "
              error_message << "#{AssertionMessage}: "
              error_message << "<#{message.inspect}>(<#{message.class}>)"
              raise ArgumentError, error_message, filter_backtrace(caller)
            end
            assertion_message ||= build_message(message,
                                                "<?> is not true.",
                                                object)
            assert_block(assertion_message) do
              object
            end
          end
        end
      end

      def assert_match(pattern, str, message="")
        string = str.to_s
        _wrap_assertion do
          pattern = case(pattern)
                    when String
                      Regexp.new(Regexp.escape(pattern))
                    else
                      pattern
                    end
          full_message = build_message(message, "<?> expected to be =~\n<?>.",
                                       string, pattern)
          assert_block(full_message) { string =~ pattern }
        end
      end
    end
  end
end
