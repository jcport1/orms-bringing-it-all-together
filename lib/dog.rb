require 'pry'

class Dog

    attr_accessor :name, :breed, :id 

def initialize(attr_hash={}) #takes in a hash argument w/ attributes

    attr_hash.each do |key, value| #iterate over the hash and create objects
        self.send("#{key.to_s}=", value) #use the send message 
    end 

end 

def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"

      DB[:conn].execute(sql, self.name, self.breed, self.id)
  end


def self.create(attr_hash)

    dog = self.new(attr_hash) #initialize method is doing the work 
    dog.save
    dog 
end 

def save 

    sql = "INSERT INTO dogs (name, breed)
    VALUES (?,?);"

    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].last_insert_row_id #set the dogs id attribute
    self #return instance

end 

def self.new_from_db(row)

    attr_hash = {
    :id => row[0],
    :name => row[1],
    :breed => row[2]
    }

    self.new(attr_hash) #initialize method
end 

def self.find_by_id(id)

    sql = "SELECT * FROM dogs WHERE id = ?;"

   DB[:conn].execute(sql,id).map do |row|
    self.new_from_db(row)
   end.first 

end 

def self.find_or_create_by(name:, breed:)

    sql = "SELECT * FROM dogs
    WHERE name = ? AND breed = ?;"

    dog = DB[:conn].execute(sql, name, breed).first

    if dog
      new_dog = self.new_from_db(dog)
    else
      new_dog = self.create({:name => name, :breed => breed})
    end
    new_dog

end 

def self.find_by_name(name)

    sql = "SELECT * FROM dogs WHERE name = ?"

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

def self.create_table

    sql = "CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT);"
    
    DB[:conn].execute(sql)

end

def self.drop_table

    sql = "DROP TABLE dogs;"

    DB[:conn].execute(sql)

end 

end 