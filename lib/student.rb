class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade
  attr_reader :id 
  
  def initialize(name, grade)
    @name = name
    @grade = grade
  end
  
  def self.create_table
    students_sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade INTEGER
        )
        SQL
    DB[:conn].execute(students_sql) 
  end
  
  def self.drop_table
    drop_sql = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(drop_sql)
  end
  
  def save
    save_sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(save_sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  def self.create(stud_hash)
    stud_hash.each{|key,value| self.send(("#{key}"), value)}
    save
  end
end
