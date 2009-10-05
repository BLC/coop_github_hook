require 'activeresource'

module Coop
  class Status < ActiveResource::Base
    self.site = "http://coopapp.com/groups/:group_id"

    def self.github_commit=(commit)
      # Currently:
      # Hero Siresh@http://github.com/main_user/project/commit/123ebb12eaf6ba3189346207daa5f9e48bf80119 : First line of commit message
      # Some day (when coop supports markup):
      # Hero Siresh@[project/123ebb12ea]:(http://github.com/main_user/project/commit/f6ba3189346207daa5f9e48bf80119): First line of commit message
      #  > Hero Siresh@[project/123ebb12ea]: First line of commit message
      self.text = "#{commit['author']['name']}@#{commit['url']} : #{commit['message'].split("\n")[0]}"
    end
  end
end