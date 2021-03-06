require_relative 'questions_database'
require_relative 'user'
require_relative 'question_follow'
require_relative 'question_like'

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
    
    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
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

    def followers
        QuestionFollow.followers_for_question_id(@id)
    end

    def likers
        QuestionLike.likers_for_question_id(@id)
    end
    def num_likes
        QuestionLike.num_likes_for_question_id(@id)
    end
end