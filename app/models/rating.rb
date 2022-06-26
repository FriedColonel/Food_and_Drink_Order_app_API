class Rating < ApplicationRecord
  trigger.after(:insert, :update) do
    <<-SQL
      UPDATE products
      SET rating = (SELECT AVG(vote) FROM ratings WHERE product_id = NEW.product_id)
      WHERE id = NEW.product_id;
    SQL
  end

  trigger.after(:delete) do
    <<-SQL
    UPDATE products
    SET rating = (SELECT AVG(vote) FROM ratings WHERE product_id = OLD.product_id)
    WHERE id = OLD.product_id;
    SQL
  end

  validates :vote, numericality: {greater_than_or_equal_to: 1,
                                  less_than_or_equal_to: 5,
                                  only_integer: true}
  belongs_to :user
  belongs_to :product
end
