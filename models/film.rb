require_relative('../db/sql_runner.rb')
require_relative('customer.rb')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @title = options['title']
    @price = options['price'].to_f
    @id = options['id'].to_i if options['id']
  end

  def customers()
    sql = "SELECT * FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE film_id = $1
    ORDER BY name"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    result = customers.map{|customer| Customer.new(customer)}
    return result
  end

  def save()
    sql = "INSERT INTO films (title, price)
    VALUES ($1, $2)
    RETURNING id;"
    values = [@title, @price]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price)
    = ($1, $2)
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films;"
    films = SqlRunner.run(sql)
    result = films.map{|film| Film.new(film)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
  end

end
