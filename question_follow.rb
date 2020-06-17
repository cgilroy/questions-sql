require_relative 'user.rb'

class QuestionFollow
    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.execute(<<-SQL, question_id)
            SELECT DISTINCT
                users.id, users.fname, users.lname
            FROM
                users
            JOIN
                question_follows
            ON  
                question_follows.question_id = ?
        SQL
        data.map { |user_data| User.new(user_data) }
    end
end