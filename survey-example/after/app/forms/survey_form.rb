class SurveyForm < ActiveForm::Base
  self.main_model = :survey
  
  attribute :name, required: true

  association :questions, records: 1 do
    attribute :content, required: true

    association :answers, records: 2 do
      attribute :content, required: true
    end
  end
end