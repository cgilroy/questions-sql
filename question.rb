require_relative 'questions_database'
require_relative 'user'

class Question
    def self.find_by_author_id(id)
        data = QuestionsDatabase.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                questions.user_id = ?
        SQL
        data.map { |data| Question.new(data) }
    end
    def self.find_by_id(id)
        data = QuestionsDatabase.get_first_row(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                questions.id = ?
        SQL
        return Question.new(data) if !data.nil?
        nil
    end
    def initialize(options)
        @id, @title, @body, @user_id = options.values_at('id', 'title', 'body', 'user_id')
    end

    def author 
        User.find_by_user_id(@user_id)
    end

    def replies
        Reply.find_by_question_id(@id)
    end
end