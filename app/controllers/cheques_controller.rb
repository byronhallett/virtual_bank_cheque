require 'RMagick'
include Magick

class ChequesController < ApplicationController

	# Called when routed to cheque path
	def index
		if params[:name] != nil
			@cheques = Array(Cheque.where(name: params[:name]))
  	else
  		@cheques = Cheque.all
  	end
	end

	# Called when a single cheque path is routed by id
	def show
		@cheque = Cheque.find(params[:id])
		drawAndSaveCheque(@cheque.name, @cheque.date, @cheque.nominal_value)
	end

	# Called on GET of new_chequq_path
	def new
	end
	
	# cheques POST /cheques(.:format) cheques#create
	def create
		if params[:button_name] != "cancel"
			@cheque = Cheque.new(cheque_params)
			@cheque.save
			redirect_to @cheque
		end
	end

	# Cheque DELETE /cheques/:id(.:format) cheques#destroy
	def destroy
		@cheque = Cheque.find(params[:id])
		@cheque.destroy

		redirect_to cheques_path
	end

	private
	  def cheque_params
	    params.require(:cheque) .permit(:name, :date, :nominal_value)
	  end
	
	# Method for performing image calculations
	# TODO: Replace statically sized labels with dynamic font size to fit line
	# TODO: Add an initial resize to 1000 x something pixels to universalise
	# the below translations
	# TODO: change the temp save method for the image, since simulatenous requests might
	# result in mixup of result images
	private
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
			valueNumString = sprintf("%0.02f",value).reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
			# Now, an interesting part, converting number to string as words:
			wordDollars = (value - value.modulo(1)).round.humanize
			wordCents = ((value.modulo(1) * 100).round).humanize
			valueWordString = wordDollars.to_s + " dollars and " + wordCents.to_s + " cents"
			valueWordString = valueWordString.titleize

			# Add the nominal value text to the cheque in position
			num_text = Draw.new
			num_text.annotate(@chequeImage, 0,0,1025,220, valueNumString) do
			  self.gravity = NorthWestGravity
			  self.pointsize = 30
			  self.font_family = "Arial"
			  self.font_weight = BoldWeight
			end
			word_num_text = Draw.new
			word_num_text.annotate(@chequeImage, 600,100,80,280, valueWordString) do
			  self.gravity = NorthWestGravity
			  self.pointsize = 30
			  self.font_family = "Arial"
			end
			@chequeImage.write('public/images')
		end
end
