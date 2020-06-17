require_relative 'questions_database'
require_relative 'question'
require_relative 'reply'
require_relative 'question_follow'

class User
    def self.find_by_name(fname,lname)
        user_data = QuestionsDatabase.get_first_row(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                users.fname = ? AND users.lname = ?
        SQL
        return User.new(user_data) if !user_data.nil?
        nil
    end

    def self.find_by_user_id(user_id)
        user_data = QuestionsDatabase.get_first_row(<<-SQL, user_id)
            SELECT
                *
            FROM
                users
            WHERE
                users.id = ?
        SQL
        return User.new(user_data) if !user_data.nil?
        nil
    end

    def initialize(options)
        @id, @fname, @lname = options.values_at('id','fname','lname')
    end

    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(@id)
    end
end