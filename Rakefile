desc "Copies all the contents of this over to a specified server"
task :deploy do
  require 'yaml'

  deploy_options = YAML.load(File.read('config/deploy.yml'))
  server = deploy_options['server']
  folder = deploy_options['folder']
  deploy_to = "#{server}:#{folder}"
  puts "Deploying to #{deploy_to}"
  system("scp -r * #{deploy_to}")

  revision = %x(git show --pretty=format:%H | head -n 1).chomp
  system("ssh #{server} \"echo #{revision} > #{folder}/REVISION\"")
end

task :test do
  example_push = JSON.parse(<<EOF
{ 
  "before": "5aef35982fb2d34e9d9d4502f6ede1072793222d",
  "repository": {
    "url": "http://github.com/defunkt/github",
    "name": "github",
    "description": "You're lookin' at it.",
    "watchers": 5,
    "forks": 2,
    "private": 1,
    "owner": {
      "email": "chris@ozmm.org",
      "name": "defunkt"
    }
  },
  "commits": [
    {
      "id": "41a212ee83ca127e3c8cf465891ab7216a705f59",
      "url": "http://github.com/defunkt/github/commit/41a212ee83ca127e3c8cf465891ab7216a705f59",
      "author": {
        "email": "chris@ozmm.org",
        "name": "Chris Wanstrath"
      },
      "message": "okay i give in",
      "timestamp": "2008-02-15T14:57:17-08:00",
      "added": ["filepath.rb"]
    },
    {
      "id": "de8251ff97ee194a289832576287d6f8ad74e3d0",
      "url": "http://github.com/defunkt/github/commit/de8251ff97ee194a289832576287d6f8ad74e3d0",
      "author": {
        "email": "chris@ozmm.org",
        "name": "Chris Wanstrath"
      },
      "message": "update pricing a tad",
      "timestamp": "2008-02-15T14:36:34-08:00"
    }
  ],
  "after": "de8251ff97ee194a289832576287d6f8ad74e3d0",
  "ref": "refs/heads/master"
}
EOF
  )

  push['commits'][0, 1].each do |commit|
    status = Coop::Status.from_commit_info(group_id, commit)
    puts "status.inspect: #{status.inspect}"
    status.save
  end
end