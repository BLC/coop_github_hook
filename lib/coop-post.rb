#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'highline/import'
require 'activeresource'

module Coop
  class Status < ActiveResource::Base
    self.site = "http://coopapp.com/groups/:group_id"

    # Co-op takes a pretty bogus format for their encoded status, so just force it into that format
    def encode(options={})
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<status>#{attributes['text']}</status>\n"
    end

    def self.from_commit_info(group_id, commit)
      status_text = "#{commit['author']['name']}@#{commit['url']} : #{commit['message']}"
      new(:group_id => group_id, :text => status_text)
    end
  end
end

cred_info = if File.exist?('coop-creds.yml')
  YAML.load(File.read('coop-creds.yml'))
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