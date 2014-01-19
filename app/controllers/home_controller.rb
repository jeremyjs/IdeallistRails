class HomeController < ApplicationController
	def index
    @products = Product.all
    return
	end
end
