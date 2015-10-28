require_relative 'Basics'
module F_crypt
	def self.encrypt(plain, key, rounds, transform_method, key_generator, debug=false)
		puts "\n\nE" if debug
		# Make half-blocks
		a = plain[0...plain.size/2]
		b = plain[plain.size/2...plain.size]
		puts "\t#{a} + #{b}" if debug
		# Rounds
		for round in 0...rounds
			puts "\tRound #{round}" if debug
			# Transformaion
			round_key = key_generator.call(key, round, a.size)
			puts "\tkey #{round_key}" if debug
			a = Basics.XOR(a, transform_method.call(b, round_key))
			# Block swap
			a,b = b,a 	# Parallel assignment
			puts "\t#{a} + #{b}" if debug
		end
		# Last parallel assignment
		a,b = b,a
		puts "\tlast" if debug
		puts "\t#{a} + #{b}" if debug
		# Concat
		cipher = a << b
	end

	def self.decrypt(cipher, key, rounds, transform_method, key_generator, debug=false)
		puts "\n\nD" if debug
		# Make half-blocks
		a = cipher[0...cipher.size/2]
		b = cipher[cipher.size/2...cipher.size]
		puts "\t#{a} + #{b}" if debug
		# Rounds
		for round in 0...rounds
			puts "\tRound #{round}" if debug
			# Transformaion
			round_key = key_generator.call(key, rounds-1-round, a.size)
			puts "\tkey #{round_key}" if debug
			a = Basics.XOR(a, transform_method.call(b, round_key))
			# Block swap
			a,b = b,a 	# Parallel assignment
			puts "\t#{a} + #{b}" if debug
		end
		# First parallel assignment
		a,b = b,a
		puts "\tlast" if debug
		puts "\t#{a} + #{b}" if debug
		# Concat
		cipher = a << b
	end
end
