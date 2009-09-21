class JiraLinkFormatter
  def self.format(jira_db, text)
    if text =~ /#{jira_db}-(\d+)/
      
    else
      text
    end
  end
end