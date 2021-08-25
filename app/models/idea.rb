class Idea < ApplicationRecord
  belongs_to :category
  with_options presence: true do
    validates  :body, :category_id
  end
end
