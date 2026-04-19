FactoryBot.define do
    factory :article do
        title { "Article's title" }
        body { "Article's body" }
        tags { [ "science" ] }

        trait :published do
            published { true }
            published_at { Date.today }
        end

        trait :draft do
            published { false }
        end
    end
end
