require 'json'

def has_data?(file_name)
  File.exist?(file_name) && File.size(file_name) > 0
end

class Database
  def initialize(file_name)
    @file_name = file_name
    @store = {}

    if has_data?(@file_name)
      self.restore!
    end

    @file = self.open
  end

  def get(key)
    @store[key]
  end

  def set(key, value)
    @store[key] = value
    line = "#{has_data?(@file_name) ? ",\n" : ""}#{key.to_json}: #{value.to_json}"
    self.append(line)

    value
  end

  def append(line)
    @file.write(line)
  end

  def drop!
    @store = {}
    @file.truncate(0)
  end

  def delete!
    self.drop!
    File.delete(@file_name)
  end

  def open
    file = File.open(@file_name, mode: "a")
    file.sync = true

    file
  end

  def restore!
    json = "{\n" + File.read(@file_name, mode: "r") + "\n}"
    @store = JSON.parse(json)
  end
end