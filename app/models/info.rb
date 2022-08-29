class Info < ApplicationRecord
  validates :block, presence: true, format: {with: /\A[a-zA-Z0-9]+\z/, message: "Only Letters and numbers"} 
  validates :block_hash, presence:  { message: "require a valid block hash input!"}
end
