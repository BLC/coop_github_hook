#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'highline/import'
require File.dirname(__FILE__) + '/../lib/coop/status'

cred_info = if File.exist?('config/coop-creds.yml')
  YAML.load(File.read('config/coop-creds.yml'))
else
  {}
end

Coop::Status.user = cred_info['username'] || ask("Enter your username:  ") { |q| q.echo = true }
Coop::Status.password = cred_info['password'] || ask("Enter your password:  ") { |q| q.echo = "*" }

group_id = cred_info['group_id'] || ask("Enter the group id to update:  ") { |q| q.echo = true }

post '/coop-hook' do
  push = JSON.parse(params[:payload])
  push['commits'].each do |commit|
    CoopStatus.from_commit_info(authentication_string, group_id, commit).post
  end
end