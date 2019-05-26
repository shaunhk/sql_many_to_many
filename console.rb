require('pry')
require_relative('models/film.rb')
require_relative('models/customer.rb')
require_relative('models/ticket.rb')

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({'name' => 'Johnny', 'funds' => 25.50})
customer1.save()
customer2 = Customer.new({'name' => 'Sara', 'funds' => 42.52})
customer2.save()
film1 = Film.new({'title' => 'The Deer Hunter', 'price' => 8.20})
film1.save()
film2 = Film.new({'title' => 'The Mirror', 'price' => 6.50})
film2.save()
ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket1.save()
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film2.id})
ticket2.save()
ticket3 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})
ticket3.save()

customer1.funds = 22.10
customer1.update()
film1.price = 9.10
film1.update()
ticket1.film_id = film2.id
ticket1.update()
# ticket2.delete()
# customer2.delete()

binding.pry
nil
