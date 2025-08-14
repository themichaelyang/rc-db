require_relative "./database"

class Testing
  def self.debug_puts(*params)
    if @debug
      puts(params)
    end
  end

  def self.test_database
    Dir.mkdir("tmp") unless Dir.exist?("tmp")

    db = Database.new("tmp/test_db")
    assert_equals(db.get("a"), nil)
    assert_equals(db.set("a", 1), 1)
    assert_equals(db.get("a"), 1)
    assert_equals(db.set("a", 2), 2)
    assert_equals(db.get("a"), 2)
    assert_equals(db.set("b", 3), 3)
    assert_equals(db.get("b"), 3)

    db_copy = Database.new("tmp/test_db")
    assert_equals(db_copy.get("a"), 2)
    assert_equals(db_copy.get("b"), 3)

    db.drop!
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

    self.methods.reverse.each do |method|
      if method.start_with?("test_")
        reset_state!

        puts "Running #{method}:"
        self.send(method)

        if @@assertions_passed == @@assertion_num
          puts "✅ Passed #{method}: #{@@assertion_num - @@assertions_passed} failures + #{@@assertions_passed} passed = #{@@assertion_num} total"
        else
          puts "⛔️ Failed #{method}: #{@@assertion_num - @@assertions_passed} failures + #{@@assertions_passed} passed = #{@@assertion_num} total"
        end

        puts ''
      end
    end

    puts "Done testing!"
  end

  def self.enable_debug!
    @debug = true
  end

  def self.reset_state!
    @@assertion_num = 0
    @@assertions_passed = 0
  end
end

if ARGV.include? "--debug"
  Testing.enable_debug!
end

if ARGV.include? "--test"
  Testing.test
end