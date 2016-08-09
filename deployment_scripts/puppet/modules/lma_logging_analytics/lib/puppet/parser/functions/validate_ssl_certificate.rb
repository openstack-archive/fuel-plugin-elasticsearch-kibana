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
#   - the path to the SSL certificate
#   - the expected CN

module Puppet::Parser::Functions
    newfunction(:validate_ssl_certificate, :type => :rvalue) do |args|

        require 'time'

        certfile = args[0]

        # Check that file is a valid x509 certificate
        err_msg = `openssl x509 -noout -in #{certfile}`
        raise "'#{certfile}' is not a valid certificate" unless err_msg.chomp() == ""

        dates   = `openssl x509 -dates -noout -in #{certfile}`.gsub("\n", '')
        subject = `openssl x509 -subject -noout -in #{certfile}`.gsub("\n", '')
        pk      = `openssl rsa -check -noout -in #{certfile}`.gsub("\n",'')

        cn        = subject.match(/CN=([^\/]+)/)
        cn_found  = cn[1] if cn
        certbegin = Time.parse(dates.gsub(/.*notBefore=(.+? GMT).*/, '\1'))
        certend   = Time.parse(dates.gsub(/.*notAfter=(.+? GMT).*/, '\1'))
        now       = Time.now.utc

        if (cn_found.start_with? "*." and not args[1].end_with? cn_found[1..-1]) or
            (not cn_found.start_with? "*." and cn_found != args[1])
            raise "Found #{cn_found} as CN whereas '#{args[1]}' was expected"
        end

        raise "The certificate file doesn't contain the private key" unless pk == 'RSA key ok'
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
