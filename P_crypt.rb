module P_crypt
  def self.encrypt(plain,key,options={})
    shift = 0
    shift = 1 if options[:from_one]
    block_size = options[:block_size] || key.size;
    #====BLOCKING=====================
    blocks = Block.build(plain, block_size, fill:true)
    #---------------------------------
    #====ENCRYPTING==================
    encrypted_block = Array.new(blocks.count) { Array.new(block_size) } #Alloc

    for b in 0...blocks.count do
      for i in 0...block_size do
        encrypted_block[b][i] = blocks[b][key[i].to_i - shift]
      end
    end
    #Concat
    cipher_text = encrypted_block.join
    #--------------------------------
    return cipher_text
  end

  def self.decrypt(cipher,key,options={})
    shift = 0
    shift = 1 if options[:from_one]
    block_size = options[:block_size] || key.size;
    #====BLOCKING=====================
    blocks = Block.build(cipher, block_size, fill:true)
    #---------------------------------
    #====DECRYPTING==================
    decrypted_block = Array.new(blocks.count) { Array.new(block_size) } #Alloc
    for b in 0...blocks.count do
      for i in 0...block_size do
        decrypted_block[b][key[i].to_i - shift] = blocks[b][i]
      end
    end
    #Concat
    plain_text = decrypted_block.join
    #--------------------------------
    return plain_text
  end
end
