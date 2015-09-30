require 'csv'

class Question

end

class Quiz
  attr :num_of_questions

  def initialize(num_of_questions)
    @num_of_questions = num_of_questions

    load_data
    choose_questions
  end

  def load_questions
    @questions = CSV.read("questions.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})
  end

  # def choose_questions
  #   num_of_questions.times do |n|
  #
  #   end
  # end
end

@quiz = Quiz.new(6)
