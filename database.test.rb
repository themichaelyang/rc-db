require_relative "./database"
require_relative "./test"

class DatabaseTest < Test
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
end