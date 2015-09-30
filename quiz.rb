require 'csv'
require 'pry'

class Question
  attr :id
  attr :standard_id
  attr :strand_id

  def initialize(id, standard_id, strand_id)
    @id = id
    @standard_id = standard_id
    @strand_id = strand_id
  end

end

class Quiz
  attr :num_of_questions

  def initialize(num_of_questions)
    @num_of_questions = num_of_questions

    load_and_initialize_data
    choose_questions
  end

  def load_and_initialize_data
    @questions = CSV.read("questions.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})
    @unique_strand_ids = (@questions.map { |q| q[:strand_id] }).uniq
    @unique_standard_ids = (@questions.map { |q| q[:standard_id] }).uniq

    initialize_data
  end

  def initialize_data
    @questions = Array.new

    CSV.foreach("questions.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
      row_hash = row.to_hash
      q = Question.new(row_hash[:question_id], row_hash[:standard_id], row_hash[:strand_id])
      @questions << q
    end
  end

  def choose_questions
    chosen_questions = Array.new

    strand_count = @num_of_questions/@unique_strand_ids.length
    standard_count = @num_of_questions/@unique_standard_ids.length

    while chosen_questions.size < @num_of_questions do
      @unique_standard_ids.cycle(standard_count) do |standard_id|
        @unique_strand_ids.cycle(strand_count) do |strand_id|
          cq = @questions.select {|q| q.strand_id == strand_id && q.standard_id == standard_id }

          cq.each do |chosen_question|
            chosen_questions <<  chosen_question unless chosen_questions.any?{ |cq| cq.id == chosen_question.id }
          end
          break if chosen_questions.size == @num_of_questions
        end
        break if chosen_questions.size == @num_of_questions
      end
    end

    puts "Chosen question IDs: #{chosen_questions.map(&:id)}"
  end
end

@quiz = Quiz.new(6)
