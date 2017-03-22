#
# Cookbook Name:: tibco
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "handler::my_own_handler.rb"
## runs monitor recipe as default
include_recipe 'tibco::monitor'
