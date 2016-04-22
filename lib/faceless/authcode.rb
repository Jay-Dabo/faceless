require 'digest/md5'
require 'base64'
require 'cgi'

module Faceless
  class Authcode

    KEY_LENGTH = 4

    def initialize string, operation, expiry
      @string = string
      @operation = operation || ''
      @expiry = expiry || 0
    end

    def self.encode string, expiry = 0
      new(string, 'ENCODE', expiry).authcode
    end

    def self.decode string, expiry = 0
      new(string, 'DECODE', expiry).authcode
    end

    def authcode
      key_length = generate_encrypt_key.size

      string = determine_string
      string_ords = ords(string)
      string_length = string_ords.size

      result = ''
      box = (0..255).to_a

      random_key = 0.upto(255).map do |i|
        (generate_encrypt_key[i % key_length]).ord
      end

      j = i = 0
      while i < 256 do
        j = (j + box[i] + random_key[i]) % 256
        box[i], box[j] = box[j], box[i]
        i += 1
      end

      a = j = i = 0
      while i < string_length
        a = (a + 1) % 256
        j = (j + box[a]) % 256
        box[a], box[j] = box[j], box[a]
        result += (string_ords[i] ^ (box[(box[a] + box[j]) % 256])).chr
        i += 1
      end

      return_result result
    end

    private

    def auth_token
      @auth_token ||= Faceless.configuration.auth_token
    end

    def result_match? result
      (result[0,10] == '0'*10 || (result[0, 10]).to_i - Time.now.to_i > 0) &&
        result[10, 16] == (md5(result[26..-1] + keyb))[0, 16]
    end

    def base_key
      @base_key ||= md5(auth_token)
    end

    def keya
      @keya ||= md5(base_key[0, 16])
    end

    def keyb
       @keyb ||= md5(base_key[16, 16])
    end

    def keyc
      @keyc ||= begin
        if KEY_LENGTH > 0
          if @operation == 'DECODE'
            @string[0, KEY_LENGTH]
          else
            (md5(microtime()))[-KEY_LENGTH..-1]
          end
        else
          ''
        end
      end
    end

    def inject_timestamp
      timestamp = @expiry > 0 ? @expiry + Time.now.to_i : 0
      "#{sprintf('%010d', timestamp)}#{(md5(@string+keyb))[0, 16]}#{@string}"
    end

    def generate_encrypt_key
      @key ||= keya + md5(keya+keyc)
    end

    def determine_string
      if @operation == 'DECODE'
        base64_url_decode(@string[KEY_LENGTH..-1])
      else
        inject_timestamp
      end
    end

    def return_result result
      if @operation == 'DECODE'
        if result_match? result
          result[26..-1]
        else
          ''
        end
      else
        "#{keyc}#{(Base64.encode64(result)).gsub(/\=/, '')}"
      end
    end

    def md5 s
      Digest::MD5.hexdigest(s)
    end
   
    def base64_url_decode str
      str += '=' * (4 - str.length.modulo(4))
      Base64.decode64(str.tr('-_','+/'))
    end
   
    def microtime
      epoch_mirco = Time.now.to_f
      epoch_full = Time.now.to_i
      epoch_fraction = epoch_mirco - epoch_full

      "#{epoch_fraction} #{epoch_full}"
    end
   
    def ords(s)
      s.bytes.to_a
    end

  end
end