class ChequesController < ApplicationController
	def new
	end
	
	def create
		@cheque = Cheque.new(cheque_params)
 
  	@cheque.save
  	redirect_to @cheque
	end

	private
	  def cheque_params
	    params.require(:cheque) .permit(:name, :date, :nominal_value)
	  end

end
