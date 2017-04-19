require 'rugged'
require 'yaml'

class Nag
  attr_accessor :repo_list
  def initialize
    @repo_list = YAML.load_file(__dir__ + '/repos.yml')
    main
  end

  def main
    repo_list.each do |r|
      repo = Rugged::Repository.new(r[:dir])
      time_diff = (Time.now - repo.last_commit.time) / 60 / 60 / 24
      message = "It has been #{time_diff.round} days since your last commit to #{repo.workdir}"
      # puts message
      puts `echo #{message} | terminal-notifier -title Nag -sound glass -appIcon images/icon.png -contentImage image/icon.png`
    end
  end
end
