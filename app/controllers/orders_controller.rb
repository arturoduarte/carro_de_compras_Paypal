class OrdersController < ApplicationController
	before_action :authenticate_user!
	
	def empty_cart
		@orders = current_user.orders.where(payed: false)
		@orders.destroy_all
		redirect_to orders_path, notice: 'El carro se ha vaciado.'
	end
	
	def index
		@orders = current_user.orders.where(payed: false)
		@total = @orders.map{ |order| order.product.price * order.quantity }.sum()
		
	end
	
	
	def create
		@product = Product.find(params[:product_id])
		
		orden = Order.find_or_create_by(user: current_user, payed: false, product: @product)
		orden.quantity += 1
		
		
		if orden.save
			redirect_to root_path, notice: 'EL producto ha sido agregado al carro'
		end
	end
	
	def destroy
		@order = Order.find(params[:id])
		if @order.quantity == 1
			@order.destroy
		elsif @order.quantity > 1
			new_quantity = @order.quantity - 1
			@order.update(quantity: new_quantity)
		end
		
		redirect_to orders_path, notice: 'Carro actualizado'
	end
	
	
end
