require 'csv'
require 'pry'

class Strand
  attr :id

  def initialize(id)
    @id = id
  end
end

class Standard
  attr :id
  attr :strand_id

  def initialize(id, strand_id)
    @id = id
    @strand_id = strand_id
  end

end

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
    # choose_questions
  end

  def load_and_initialize_data
    @questions = CSV.read("questions.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})
    @unique_strand_ids = (@questions.map { |q| q[:strand_id] }).uniq
    @unique_standard_ids = (@questions.map { |q| q[:standard_id] }).uniq
    @unique_question_ids = (@questions.map { |q| q[:question_id] }).uniq

    initialize_data
  end

  def initialize_data
    @strands, @standards, @questions = Array.new

    # @unique_strand_ids.each do |strand_id|
    #   @strands << Strand.new(strand_id)
    # end

    CSV.foreach("questions.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
      row_hash = row.to_hash
      q = Question.new(row_hash[:question_id], row_hash[:standard_id], row_hash[:strand_id])
    end
  end

  def choose_questions
    chosen_questions = Array.new
    while chosen_questions.size < num_of_questions do
        @unique_strand_ids.cycle do |strand_id|

        end

    end
  end
end

@quiz = Quiz.new(6)
