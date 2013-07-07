class Survey::Answer < ActiveRecord::Base

  self.table_name = "survey_answers"
  belongs_to :attempt
  belongs_to :option
  belongs_to :question

  validates :option_id, :question_id, :presence => true
  attr_accessible :option, :attempt, :question, :question_id, :option_id
  validates_uniqueness_of :question_id, :scope => [:attempt_id]
  before_create :characterize_answer

  def value
    unless self.option == nil
      self.option.weight
    else
      Survey::Option.find(option_id).weight
    end
  end

  def correct?
    unless self.option == nil
      self.correct or self.option.correct?
    else
      Survey::Option.find(option_id).correct?
    end
  end

  private

  def characterize_answer
    if option.correct?
      self.correct = true
    else
      self.correct = false
    end
  end

end
