class Block
	def self.build(data,block_size, options={})
		#Expand
		if options[:fill] && (data.size % block_size) != 0
			data += " "*(block_size - (data.size % block_size)).to_i #fill
		end
		#Processing
		block_count = data.size / block_size;
		blocks = Array.new
		for i in 0...block_count do
		  blocks[i] = data[(i*block_size...(i+1)*block_size)]
		end
		return blocks
	end
end
