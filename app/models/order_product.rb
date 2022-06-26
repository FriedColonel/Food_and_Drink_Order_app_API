class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  trigger.after(:delete) {
    <<-SQL
      WITH total_cost AS (
        SELECT SUM(products.price * order_products.quantity) AS "cost" FROM order_products
        JOIN products ON order_products.product_id = products.id
        WHERE order_products.order_id = OLD.order_id
      )
      UPDATE orders
      SET total = (SELECT * FROM total_cost)
      WHERE id = OLD.order_id;
    SQL
  }

  trigger.after(:insert, :update) {
    <<-SQL
      WITH total_cost AS (
        SELECT SUM(products.price * order_products.quantity) AS "cost" FROM order_products
        JOIN products ON order_products.product_id = products.id
        WHERE order_products.order_id = NEW.order_id
      )
      UPDATE orders
      SET total = (SELECT * FROM total_cost)
      WHERE id = NEW.order_id;
    SQL
  }
end
