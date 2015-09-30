require 'csv'
require 'pry'

# class Strand
#   attr :id
#
#   def initialize(id)
#     @id = id
#   end
# end
#
# class Standard
#   attr :id
#   attr :strand_id
#
#   def initialize(id, strand_id)
#     @id = id
#     @strand_id = strand_id
#   end
#
# end

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

  # def choose_questions
  #   chosen_questions = Array.new
  #
  #   # strand_count = @num_of_questions/@unique_strand_ids.length
  #   # standard_count = @num_of_questions/@unique_standard_ids.length
  #
  #   (1..@num_of_questions).each do |n|
  #     strand_index = n % @unique_strand_ids.length
  #     standard_index = n % @unique_standard_ids.length
  #     strand_id = @unique_strand_ids[strand_index]
  #     standard_id = @unique_standard_ids[standard_index]
  #
  #     cq = @questions.select {|q| q.strand_id == strand_id && q.standard_id == standard_id }
  #     binding.pry
  #     cq.each do |chosen_question|
  #       binding.pry
  #       chosen_questions <<  chosen_question unless chosen_questions.any?{ |cq| cq.id == chosen_question.id }
  #     end
  #
  #     # binding.pry
  #   end
  #
  #   # binding.pry
  # end

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

    binding.pry
  end
end

@quiz = Quiz.new(6)
