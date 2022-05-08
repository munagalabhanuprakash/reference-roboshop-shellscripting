frontend:
	@bash components/01-frontend.sh

mongodb:
	@bash components/02-mongodb.sh

catalogue:
	@bash components/03-catalogue.sh

redis:
	@bash components/04-redis.sh

user:
	@bash components/05-user.sh

cart:
	@bash components/06-cart.sh

mysql:
	@bash components/07-mysql.sh

shipping:
	@bash components/08-shipping.sh

rabbitmq:
	@bash components/09-rabbitmq.sh