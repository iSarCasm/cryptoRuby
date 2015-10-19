module S_crypt
  SYSTEM_SYMBOLS = 32
  ASCII_RANGE = 256**1 # 1 byte max
  UTF_8_RANGE = 256**4 # 4 bytes max

  def self.encrypt(plain,key,options={})
    #Reading data---------------------
    if key.class== Fixnum
      block_size = 1
      key = [key]
    end
    if options[:string_key]
      key = (key.split("").collect {|k| k.ord})
    end
    char_range = -SYSTEM_SYMBOLS + case plain.encoding
      when Encoding::UTF_8 then UTF_8_RANGE
      else ASCII_RANGE
    end
    #====BLOCKING=====================
    block_size = key.size
    blocks = Block.build(plain, block_size, fill:true)
    #---------------------------------
    #====ENCRYPTING==================
    encrypted_block = Array.new(blocks.count) { Array.new(block_size) }
    for b in 0...blocks.count do
      for i in 0...block_size do
        if blocks[b][i].ord > SYSTEM_SYMBOLS-1 #Not system
          encrypted_block[b][i] = ((blocks[b][i].ord + key[i].to_i - SYSTEM_SYMBOLS)%char_range + SYSTEM_SYMBOLS).chr(plain.encoding)
        else
          encrypted_block[b][i] = blocks[b][i]
        end
      end
    end
    #Concat
    cipher_text = encrypted_block.join
    cipher_text = cipher_text[0...plain.size]
    #--------------------------------
    return cipher_text
  end

  def self.decrypt(cipher,key,options={})
    p "\n"
    #Reading data---------------------
    if key.class == Fixnum
      block_size = 1
      key = [key]
    end
    block_size = key.size
    if options[:string_key]
      key = (key.split("").collect {|k| k.ord})
    end
    char_range = -SYSTEM_SYMBOLS + case cipher.encoding
      when Encoding::UTF_8 then UTF_8_RANGE
      else ASCII_RANGE
    end
    #====BLOCKING=====================
    block_size = key.size
    blocks = Block.build(cipher, block_size, fill:true)
    #---------------------------------
    #====ENCRYPTING==================
    decrypted_block = Array.new(blocks.count) { Array.new(block_size) }
    for b in 0...blocks.count do
      for i in 0...block_size do
        if blocks[b][i].ord > SYSTEM_SYMBOLS-1 #Not System
          decrypted_block[b][i] = ((blocks[b][i].ord - key[i].to_i - SYSTEM_SYMBOLS)%char_range + SYSTEM_SYMBOLS).chr(cipher.encoding)
        else
          decrypted_block[b][i] = blocks[b][i]
        end
      end
    end
    #Concat
    plain_text = decrypted_block.join
    plain_text = plain_text[0...cipher.size]
    #--------------------------------
    return plain_text
  end
end
