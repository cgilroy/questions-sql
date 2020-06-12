require_relative 'questions_database'

class Reply
    def self.find_by_user_id(user_id)
        reply_data = QuestionsDatabase.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE
                replies.user_id = ?
        SQL
        return nil if reply_data.nil?
        reply_data.map { |data| Reply.new(data) }
    end

    def self.find_by_question_id(question_id)
        reply_data = QuestionsDatabase.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                replies.question_id = ?
        SQL
        return nil if reply_data.nil?
        reply_data.map { |data| Reply.new(data) }
    end

    def initialize(options)
        @id, @question_id, @parent_id, @body, @user_id = options.values_at('id','question_id','parent_id','body','user_id')
    end
end