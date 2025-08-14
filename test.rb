Dir[File.join(__dir__, '**/*.test.rb')].each { |file| require file }

class Test
  def debug_puts(*params)
    if @@debug
      puts(params)
    end
  end

  def self.assert_equals(actual, expected)
    @@assertion_num += 1

    if actual == expected
      puts "- Check #{@@assertion_num} passed!"
      @@assertions_passed += 1
    else
      puts "-️ 💥 Check #{@@assertion_num} failed! #{actual} != #{expected}"
    end
  end

  def self.test
    puts "Testing..."
    puts ''

    Test.subclasses.each do |subclass|
      subclass.methods.each do |method|
        if method.start_with?("test_")
          reset_state!

          puts "Running #{method}:"
          subclass.send(method)

          if @@assertions_passed == @@assertion_num
            puts "✅ Passed #{method}: #{@@assertion_num - @@assertions_passed} failures + #{@@assertions_passed} passed = #{@@assertion_num} total"
          else
            puts "⛔️ Failed #{method}: #{@@assertion_num - @@assertions_passed} failures + #{@@assertions_passed} passed = #{@@assertion_num} total"
          end

          puts ''
        end
      end
    end

    puts "Done testing!"
  end

  def self.enable_debug!
    @@debug = true
  end

  def self.reset_state!
    @@assertion_num = 0
    @@assertions_passed = 0
  end
end

if ARGV.include? "--debug"
  Test.enable_debug!
end

if ARGV.include? "--test"
  Test.test
end