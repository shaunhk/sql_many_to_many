require_relative('../db/sql_runner.rb')
require_relative('ticket.rb')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @name = options['name']
    @funds = options['funds'].to_f
    @id = options['id'].to_i if options['id']
  end

  def purchase_ticket()
    sql = "SELECT * FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE customer_id = $1"
    values = [@id]
    films_hash = SqlRunner.run(sql, values)
    films = films_hash.map{|film| Film.new(film)}
    purchases = films.each{|film| film.price}
    purchases = purchases.sum
    @funds -= purchases
  end

  def films()
    sql = "SELECT * FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE customer_id = $1
    ORDER BY title"
    values = [@id]
    films = SqlRunner.run(sql, values)
    result = films.map{|film| Film.new(film)}
    return result
  end

  def save()
    sql = "INSERT INTO customers (name, funds)
    VALUES ($1, $2)
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds)
    = ($1, $2)
    WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers;"
    customers = SqlRunner.run(sql)
    result = customers.map{|customer| Customer.new(customer)}
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end

end
