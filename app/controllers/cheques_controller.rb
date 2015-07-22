require 'RMagick'
include Magick

class ChequesController < ApplicationController
	def index
    	@cheques = Cheque.all
  	end

	def show		
		# Create a 100x100 red image.
		image = Image.new(100,100) { self.background_color = "red" }
		image.display
		exit
		@cheque = Cheque.find(params[:id])
	end

	def new
	end
	
	def create
		@cheque = Cheque.new(cheque_params)
 		
		@cheque.save
		redirect_to @cheque
	end

	def destroy
		@cheque = Cheque.find(params[:id])
		@cheque.destroy

		redirect_to cheques_path
	end

	private
	  def cheque_params
	    params.require(:cheque) .permit(:name, :date, :nominal_value)
	  end
end
