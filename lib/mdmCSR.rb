require "mdmCSR/version"
require 'nokogiri'
require 'base64'

module MdmCSR
  class Certificate
  
    attr_reader :country, :state, :city, :department, :organization,
                :common_name, :email

    def initialize(country:, state:, city:, department:, organization:,
                    common_name:, email:)

      @country      = country
      @state        = state
      @city         = city
      @department   = department
      @organization = organization
      @common_name  = common_name
      @email        = email

      generate_csr
    end

    private

    def generate_csr

      rsa_key = OpenSSL::PKey::RSA.new(2048)

      digest = OpenSSL::Digest::SHA256.new  
      request = OpenSSL::X509::Request.new.tap do |r|
        r.version = 0
        r.subject = OpenSSL::X509::Name.new([
          ["C",             @country,      OpenSSL::ASN1::PRINTABLESTRING],
          ["ST",            @state,        OpenSSL::ASN1::PRINTABLESTRING],
          ["L",             @city,         OpenSSL::ASN1::PRINTABLESTRING],
          ["O",             @organization, OpenSSL::ASN1::UTF8STRING],
          ["OU",            @department,   OpenSSL::ASN1::UTF8STRING],
          ["CN",            @common_name,  OpenSSL::ASN1::UTF8STRING],
          ["emailAddress",  @email,        OpenSSL::ASN1::UTF8STRING]
        ])
        
        r.public_key = rsa_key.public_key
        r.sign(rsa_key, digest)
      end
     
      csr_64 = Base64.encode64(request.to_der) 
      
      signature = sign_csr(request.to_der)

      create_plist(csr_64, signature)
    end

    def create_plist(csr_64, signature)

      load_certificates

      builder = Nokogiri::XML::Builder.new do |xml|
        xml.doc.create_internal_subset(
          'plist',
          "-//Apple//DTD PLIST 1.0//EN",
          "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
        )
        xml.plist('version' => '1.0') do
          xml.dict do
            xml.key "PushCertRequestCSR"
            xml.string csr_64
            xml.key "PushCertSignature"
            xml.string signature
            xml.key "PushCertCertificateChain"
            xml.string "#{@mdm_cert}#{@apple_cert}#{@apple_root_cert}"
          end
        end
      end

      plist_file = File.new("certificate_signing_request.plist", "w")
      plist_file.puts(Base64.encode64(builder.to_xml))
      plist_file.close
    end

    def load_private_key
      vendor = OpenSSL::PKCS12.new(File.read "certificates/vendor.p12")
      vendor.key
    end

    def load_certificates
      @apple_root_cert = File.read "certificates/root.pem"
      @apple_cert = File.read "certificates/intermediate.pem"
      @mdm_cert = File.read "certificates/mdm.pem"
    end

    def sign_csr(csr_content)
      digest = OpenSSL::Digest::SHA1.new
      private_key = load_private_key
      Base64.encode64(private_key.sign(digest, csr_content))
    end

  end
end
