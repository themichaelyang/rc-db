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
    File.write(@file_name, line, mode: "a")
  end

  def drop!
    @store = {}
    File.delete(@file_name)
  end

  def restore!
    json = "{\n" + File.read(@file_name, mode: "r") + "\n}"
    @store = JSON.parse(json)
  end
end