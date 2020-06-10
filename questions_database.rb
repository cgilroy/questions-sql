require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
    include Singleton
    def self.open
        @db = SQLite3::Database.new('aa_questions.db')
        @db.results_as_hash = true
        @db.type_translation = true
    end

    def self.instance
        reset_db if @db.nil?
        @db
    end
    def self.execute(*args) 
        instance.execute(*args)
    end

    def self.get_first_row(*args)
        instance.get_first_row(*args)
    end

    def self.get_first_value(*args)
        instance.get_first_value(*args)
    end

    def self.last_insert_row_id
        instance.last_insert_row_id
    end
    
    def self.reset_db
        `cat import_db.sql | sqlite3 aa_questions.db`
        QuestionsDatabase.open
    end
end