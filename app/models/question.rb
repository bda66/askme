# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user
  belongs_to :questioning_user, class_name: 'User', optional: true

  validates :user, presence: true
  validates :text, presence: true, length: { maximum: 255 }
end
