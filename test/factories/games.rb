FactoryGirl.define do
  factory :game do
    word 'banana'
    mode 'rhyme'
    over_at Time.now + 5.minutes
  end
end
