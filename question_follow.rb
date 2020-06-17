require_relative 'user.rb'

class QuestionFollow
    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.execute(<<-SQL, question_id)
            SELECT
                users.id, users.fname, users.lname
            FROM
                users
            JOIN
                question_follows
            ON
                question_follows.user_id = users.id
            WHERE
                question_follows.question_id = ?
        SQL
        data.map { |user_data| User.new(user_data) }
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_follows
            ON
                question_follows.question_id = questions.id
            WHERE
                question_follows.user_id = ?
            
        SQL
        data.map { |question_data| Question.new(question_data) }
    end
end