require 'RMagick'
include Magick

class ChequesController < ApplicationController
	
	def drawAndSaveCheque (name, date, value)
		@chequeImage = ImageList.new('app/assets/images/cheque.png')
		# Add the name text to the cheque in position
		name_text = Draw.new
		name_text.annotate(@chequeImage, 0,0,210,215, name) do
		  self.gravity = NorthWestGravity
		  self.pointsize = 30
		  self.font_family = "Arial"
		end
		# Calculate a usable date string
		dateString = date.strftime("%d / %m / %Y")
		# Add the date text to the cheque in position
		date_text = Draw.new
		date_text.annotate(@chequeImage, 0,0,850,130, dateString) do
		  self.gravity = NorthWestGravity
		  self.pointsize = 30
		  self.font_family = "Arial"
		end
		# Calculate both numeric and worded strings for value
		valueNumString = value.to_s
		# Now, an interesting part, converting number to string as words:
		wordDollars = (value - value.modulo(1)).round.humanize
		wordCents = ((value.modulo(1) * 100).round).humanize
		valueWordString = wordDollars.to_s + " dollars and " + wordCents.to_s + " cents"
		valueWordString = valueWordString.titleize

		# Add the nominal value text to the cheque in position
		num_text = Draw.new
		num_text.annotate(@chequeImage, 0,0,1020,220, valueNumString) do
		  self.gravity = NorthWestGravity
		  self.pointsize = 30
		  self.font_family = "Arial"
		  self.font_weight = BoldWeight
		end
		word_text = Draw.new
		word_text.annotate(@chequeImage, 600,100,80,280, valueWordString) do
		  self.gravity = NorthWestGravity
		  self.pointsize = 30
		  self.font_family = "Arial"
		end
		@chequeImage.write('public/images')
	end

	def index
		if params[:name] != nil
			@cheques = Array(Cheque.find_by(name: params[:name]))
  	else
  		@cheques = Cheque.all
  	end
	end

	def show
		@cheque = Cheque.find(params[:id])
		drawAndSaveCheque(@cheque.name, @cheque.date, @cheque.nominal_value)
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
