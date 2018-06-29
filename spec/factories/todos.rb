FactoryBot.define do
  factory :todo do
    sequence(:title) { |i| "title_#{i}" }
    sequence(:text) { |i| "text_#{i}" }
  end
end
