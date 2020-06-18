require_relative 'questions_database'
require_relative 'user'

class QuestionLike
    def self.likers_for_question_id(question_id)
        data = QuestionsDatabase.execute(<<-SQL, question_id)
            SELECT
                users.*
            FROM
                users
            JOIN
                question_likes
            ON
                users.id = question_likes.user_id
            WHERE
                question_likes.question_id = ?
        SQL
        data.map { |user_data| User.new(user_data) }
    end

    def self.liked_questions_for_user_id(user_id)
        data = QuestionsDatabase.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                questions
            JOIN
                question_likes
            ON
                questions.id = question_likes.question_id
            WHERE
                question_likes.user_id = ?
        SQL
        data.map { |questions_data| Question.new(questions_data) }
    end

    def self.num_likes_for_question_id(question_id)
        count = QuestionsDatabase.get_first_value(<<-SQL, question_id)
            SELECT
                COUNT(users.id) as like_count
            FROM
                users
            JOIN
                question_likes
            ON
                users.id = question_likes.user_id
            WHERE
                question_likes.question_id = ?
        SQL
        count
    end
end