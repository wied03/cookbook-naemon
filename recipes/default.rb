# Encoding: utf-8
#
# Cookbook Name:: naemon
# Recipe:: default
#
# Copyright 2014, BSW Technology Consulting
#

# Sample usage (tested on real Chef)

# naemon_command 'the_command' do
#   command_line '/etc/do_stuff'
# end
#
# naemon_role 'db' do
#   service 'naemon apache service' do
#     check_command 'the_command'
#   end
# end
#
# This would actually need to be the Naemon service
# service 'apache2' do
#   action :nothing
#   subscribes :restart, 'template[/etc/naemon/conf.d/hosts.cfg]', :delayed
# end

#TODO: Incorporate packages, service setup, username/password setup for Apache