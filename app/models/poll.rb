class Poll < ApplicationRecord

  belongs_to :user

  validates :name, format: { with: /\A[a-zA-Z]+\z/, message: "Only allows alphabets" }, presence: true
  validates :time_in_seconds, numericality: { only_integer: true }




end