# Inspired by cert_date_valid.rb found at
# https://github.com/camptocamp/puppet-openssl
#
# Function: validate_ssl_certificate()
#
# Checks SSL certificate date and CN validity. It also checks that the private
# key is embedded into the certificate.
#
# It raises an exception if:
#   - the certificate has no private key
#   - the CN of the certificate and the CN provided as argument don't match
#   - the date is not found in the certificate
#
# It returns false if the certificate is expired or not yet valid
# Otherwise it returns the number of seconds before the certificate expires
#
# Parameter:
#   - the content of the SSL certificate
#   - the expected CN

module Puppet::Parser::Functions
    newfunction(:validate_ssl_certificate, :type => :rvalue) do |args|

        require 'tempfile'
        require 'time'

        file = Tempfile.new('certificate')
        begin
          cert_content = args[0]
          file.write(cert_content)
          file.close

          # Check that file is a valid x509 certificate
          err_msg = `openssl x509 -noout -in #{file.path}`
          raise "'#{file.path}' is not a valid certificate" unless err_msg.chomp() == ""

          dates   = `openssl x509 -dates -noout -in #{file.path}`.gsub("\n", '')
          subject = `openssl x509 -subject -noout -in #{file.path}`.gsub("\n", '')
          pk      = `openssl rsa -check -noout -in #{file.path}`.gsub("\n",'')

          cn        = subject.match(/CN=(.*)$/)[1]
          certbegin = Time.parse(dates.gsub(/.*notBefore=(.+? GMT).*/, '\1'))
          certend   = Time.parse(dates.gsub(/.*notAfter=(.+? GMT).*/, '\1'))
          now       = Time.now.utc
        ensure
          file.unlink
        end

        raise "The certificate file doesn't contain the private key" unless pk == 'RSA key ok'
        raise "Found '#{cn}' as CN whereas '#{args[1]}' was expected" unless cn == args[1]
        raise "Dates not found in the certificate" unless dates.match(/not(Before|After)=/)

        if (now > certend)
            Puppet.warning("Certificate has expired. End date: #{certend}")
            false
        elsif (now < certbegin)
            Puppet.warning("Certificate is not yet valid. Start date: #{certbegin}")
            false
        elsif (certend <= certbegin)
            Puppet.warning("Certificate will never be valid")
            false
        else
            # return the number of seconds before the certificate expires
            (certend - now).to_i
        end

    end
end
