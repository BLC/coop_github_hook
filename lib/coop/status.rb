require 'activeresource'

module Coop
  class Status < ActiveResource::Base
    self.site = "http://coopapp.com/groups/:group_id"

    # Co-op takes a pretty bogus format for their encoded status, so just force it into that format
    def encode(options={})
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<status>#{attributes['text']}</status>\n"
    end

    def self.from_github_commit_info(group_id, commit)
      status_text = "#{commit['author']['name']}@#{commit['url']} : #{commit['message'].split("\n")[0]}"
      new(:group_id => group_id, :text => status_text)
    end
  end
end