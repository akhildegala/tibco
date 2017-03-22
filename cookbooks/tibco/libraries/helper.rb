require 'net/smtp'


module HandlerSendEmail
  class Helper
    def send_email_on_modify(node_name, from_address, to_address, content)
      message = "From: Chef <#{from_address}>\n"
      message << "To: Akhil <#{to_address}>\n"
      message << "Subject: Chef node updated tiebsm.conf\n"
      message << "Date: #{Time.now.rfc2822}\n\n"
      message << "Chef client updated below paramters on #{node_name}\n\n"
      message << "#{content}"	
      Net::SMTP.start('localhost', 25) do |smtp|
        smtp.send_message message, "#{from_address}", "#{to_address}"
      end
    end
  end
end
