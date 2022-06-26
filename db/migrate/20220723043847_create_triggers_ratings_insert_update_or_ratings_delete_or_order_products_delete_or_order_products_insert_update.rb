# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersRatingsInsertUpdateOrRatingsDeleteOrOrderProductsDeleteOrOrderProductsInsertUpdate < ActiveRecord::Migration[6.1]
  def up
    drop_trigger("ratings_after_insert_row_tr", "ratings", :generated => true)

    drop_trigger("order_products_after_update_delete_row_tr", "order_products", :generated => true)

    create_trigger("ratings_after_insert_update_row_tr", :generated => true, :compatibility => 1).
        on("ratings").
        after(:insert, :update) do
      <<-SQL_ACTIONS
      UPDATE products
      SET rating = (SELECT AVG(vote) FROM ratings WHERE product_id = NEW.product_id)
      WHERE id = NEW.product_id;
      SQL_ACTIONS
    end

    create_trigger("ratings_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("ratings").
        after(:delete) do
      <<-SQL_ACTIONS
    UPDATE products
    SET rating = (SELECT AVG(vote) FROM ratings WHERE product_id = OLD.product_id)
    WHERE id = OLD.product_id;
      SQL_ACTIONS
    end

    create_trigger("order_products_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("order_products").
        after(:delete) do
      <<-SQL_ACTIONS
      WITH total_cost AS (
        SELECT SUM(products.price * order_products.quantity) AS "cost" FROM order_products
        JOIN products ON order_products.product_id = products.id
        WHERE order_products.order_id = OLD.order_id
      )
      UPDATE orders
      SET total = (SELECT * FROM total_cost)
      WHERE id = OLD.order_id;
      SQL_ACTIONS
    end

    create_trigger("order_products_after_insert_update_row_tr", :generated => true, :compatibility => 1).
        on("order_products").
        after(:insert, :update) do
      <<-SQL_ACTIONS
      WITH total_cost AS (
        SELECT SUM(products.price * order_products.quantity) AS "cost" FROM order_products
        JOIN products ON order_products.product_id = products.id
        WHERE order_products.order_id = NEW.order_id
      )
      UPDATE orders
      SET total = (SELECT * FROM total_cost)
      WHERE id = NEW.order_id;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("ratings_after_insert_update_row_tr", "ratings", :generated => true)

    drop_trigger("ratings_after_delete_row_tr", "ratings", :generated => true)

    drop_trigger("order_products_after_delete_row_tr", "order_products", :generated => true)

    drop_trigger("order_products_after_insert_update_row_tr", "order_products", :generated => true)

    create_trigger("ratings_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("ratings").
        after(:insert, :delete, :update) do
      <<-SQL_ACTIONS
      UPDATE products
      SET rating = (SELECT AVG(vote) FROM ratings WHERE product_id = NEW.product_id)
      WHERE id = NEW.product_id;
      SQL_ACTIONS
    end

    create_trigger("order_products_after_update_delete_row_tr", :generated => true, :compatibility => 1).
        on("order_products").
        after(:insert, :update, :delete) do
      <<-SQL_ACTIONS
      WITH total_cost AS (
        SELECT SUM(products.price * order_products.quantity) AS "cost" FROM order_products
        JOIN products ON order_products.product_id = products.id
        WHERE order_products.order_id = OLD.order_id
      )
      UPDATE orders
      SET total = (SELECT * FROM total_cost)
      WHERE id = OLD.order_id;
      SQL_ACTIONS
    end
  end
end
