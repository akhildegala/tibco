## Read Checksum from last run and compare with current checksum to check if conf file is updated
ruby_block 'get_checksum' do
	block do
		if File.exist?("#{node.default[:checksum_file]}")
			cached_checksum = IO.read("#{node.default[:checksum_file]}") ## Read Checksum from last run cached file
			puts "CURRENT CHECKSUM::: #{cached_checksum}"	
		end
  	  	require 'digest'
    		checksum = Digest::SHA1.file("#{node.default[:conf_file]}").hexdigest  ## get New checksum on conf file
	    	node.default['checksum'] = "#{checksum}"
    		puts "CHECKSUM ::: #{node.default[:checksum]}"
	    	file_r = run_context.resource_collection.find(:file => "checksum")
    		file_r.content node.default[:checksum]
		resources(:ruby_block => 'fix_file').run_action(:run)
    		if cached_checksum != node.default[:checksum]  ## If conf file modified, check if params modified
			puts "Conf file is updated, checksum #{node.default[:checksum]} does not match #{checksum}"
			resources(:ruby_block => 'fix_file').run_action(:run)
		end	 
  	end
end

## update cached file with new checksum
file 'checksum' do
        path "#{node.default[:checksum_file]}"
        content  node.default[:checksum]
end

## Loop through params and verify if values different from attributes/default.rb and update them 
ruby_block 'fix_file' do
	block do
		params_updated = []
		node.default[:params].each do |name,value|
			m = File.foreach("#{node.default[:conf_file]}").grep /#{name}\s*=\s*#{value}$/
			if m.empty?
				params_updated.push("#{name}")	
				sed = Chef::Util::FileEdit.new("#{node.default[:conf_file]}")
				sed.search_file_replace_line(/^#{name}.*?\=/i, "#{name} = #{value}")
				sed.write_file
			end
		end
		if !params_updated.empty?
			node.default[:modified] = true
			node.default.params_updated = params_updated.join("\n")
		end
	end
	action :nothing
end

chef_handler 'MyOwnHandler' do
  source 'chef/handler/my_own_handler'
  action :enable
end

## Handler to Send Email on parameters updated
Chef.event_handler do
	on :run_completed do
	   if Chef.run_context.node.default.modified == true
    		HandlerSendEmail::Helper.new.send_email_on_modify(
      			Chef.run_context.node.name,
			"chef-client@#{Chef.run_context.node.fqdn}",
			"#{Chef.run_context.node.default.mail.to_address}",
			Chef.run_context.node.default.params_updated
    		)
	   end
  	end
end
