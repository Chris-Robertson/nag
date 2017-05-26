require 'rugged'
require 'yaml'

DAYS_TO_NAG_AFTER = 7

class Nag
  attr_accessor :repo_list
  def initialize
    @repo_list = YAML.load_file(__dir__ + '/repos.yml')
    main
  end

  def main
    repo_list.each do |r|
      repo = Rugged::Repository.new(r[:dir])
      days_since = time_diff(repo.last_commit.time)

      next if days_since < DAYS_TO_NAG_AFTER

      message = "It has been #{days_since} days since your last commit
                 to #{repo.workdir}"
      puts `echo #{message} | terminal-notifier -title Nag
                                                -sound glass
                                                -appIcon images/icon.png
                                                -contentImage image/icon.png`
      sleep 3
    end
  end

  def time_diff(last_commit_time)
    time_in_seconds = Time.now - last_commit_time
    time_in_days = time_in_seconds / 60 / 60 / 24
    time_in_days.round
  end
end
