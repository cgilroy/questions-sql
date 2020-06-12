require_relative 'questions_database'

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
    def initialize(options)
        @id, @title, @body, @user_id = options.values_at('id', 'title', 'body', 'user_id')
    end
end