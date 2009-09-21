require 'activeresource'

module Coop
  class Status < ActiveResource::Base
    self.site = "http://coopapp.com/groups/:group_id"

    # Co-op takes a non-ActiveResource friendly format for their status, so manually write that format
    def encode(options={})
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<status>#{attributes['text']}</status>\n"
    end

    def self.from_github_commit_info(group_id, commit)
      # Currently:
      # Hero Siresh@http://github.com/main_user/project/commit/123ebb12eaf6ba3189346207daa5f9e48bf80119 : First line of commit message
      # Some day (when coop supports markup):
      # Hero Siresh@[project/123ebb12ea]:(http://github.com/main_user/project/commit/f6ba3189346207daa5f9e48bf80119): First line of commit message
      #  > Hero Siresh@[project/123ebb12ea]: First line of commit message
      status_text = "#{commit['author']['name']}@#{commit['url']} : #{commit['message'].split("\n")[0]}"
      new(:group_id => group_id, :text => status_text)
    end
  end
end