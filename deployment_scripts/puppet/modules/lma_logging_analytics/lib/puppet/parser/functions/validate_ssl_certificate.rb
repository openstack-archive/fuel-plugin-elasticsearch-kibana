# Copied from https://github.com/camptocamp/puppet-openssl
# Original name: cert_date_valid.rb
#
# Function: validate_ssl_certificate()
#
# Checks SSL cetificate date and CN validity. It also checks that private
# key is embedded into the certificate.
#
# It raises an exception if:
#   - the certificate has no private key
#   - the CN of the certificate and the CN provided as argument doesn't match
#   - the certificate is expired or not yet valid
#
# It returns false if the date is not valid
# Otherwise it returns number of seconds certificate is still valid for.
#
# Parameter:
#   - content of the ssl certificate
#   - CN name the should be find in the certificate

module Puppet::Parser::Functions
    newfunction(:validate_ssl_certificate, :type => :rvalue) do |args|

        require 'tempfile'
        require 'time'

        file = Tempfile.new('certificate')
        begin
          cert_content = args[0]
          file.write(cert_content)
          file.rewind
          dates = `openssl x509 -dates -noout -in #{file.path}`.gsub("\n", '')
          subject = `openssl x509 -subject -noout -in #{file.path}`.gsub("\n", '')
          pk = `openssl rsa -check -noout -in #{file.path}`.gsub("\n",'')
          cn = subject.match(/CN=(.*)$/)[1]
        ensure
          file.close
          file.unlink
        end

        raise "Private key not found" unless pk == 'RSA key ok'
        raise "Certificate Common Name failed to match" unless cn == args[1]
        raise "No date found in certificate" unless dates.match(/not(Before|After)=/)

        certbegin = Time.parse(dates.gsub(/.*notBefore=(.+? GMT).*/, '\1'))
        certend   = Time.parse(dates.gsub(/.*notAfter=(.+? GMT).*/, '\1'))
        now       = Time.now

        if (now > certend)
            Puppet.info('certificate is expired')
            false
        elsif (now < certbegin)
            Puppet.info('certificate is not yet valid')
            false
        elsif (certend <= certbegin)
            Puppet.info('certificate will never be valid')
            false
        else
            # return number of seconds certificate is still valid for
            (certend - now).to_i
        end

    end
end
