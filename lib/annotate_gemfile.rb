# encoding: utf-8
require 'rubygems'
require 'bundler'
require 'rubygems'
require 'gems'
require 'github_api'

module AnnotateGemfile

  autoload :Version,    'annotate_gemfile/version'
  autoload :Parser,     'annotate_gemfile/parser'

  class Annotator

    def self.gem_info(name)
      # http://guides.rubygems.org/rubygems-org-api/
      gem_hash = Gems.info name
      {
        :name => gem_hash["name"],
        :version => gem_hash["version"],
        :platform => gem_hash["platform"],
        :info => gem_hash["info"],
        :homepage_uri => gem_hash["homepage_uri"],
        :source_code_uri => gem_hash["source_code_uri"],
        :documentation_uri => gem_hash["documentation_uri"],
      }
    end

    def self.github_repo(user_name, repo_name)
      github = Github.new
      response = github.repos.get user_name, repo_name
      repo = response.body
      {
        :id => repo.id,
        :name => repo.name,
        :description => repo.description,
        :created_at => repo.created_at,
        :updated_at => repo.updated_at,
        :pushed_at => repo.pushed_at,
        :full_name => repo.full_name,
        :html_url => repo.html_url,
        :homepage => repo.homepage,
        :ssh_url => repo.ssh_url,
        :clone_url => repo.clone_url,
        :git_url => repo.git_url,
        :svn_url => repo.svn_url,
      }
    end

    def self.datetime_string
      Time.now.strftime("%m-%d-%y-%H_%M_%S")
    end

    def initialize(path)
      @gemfile_path = path
    end

    def backup_gemfile
      @gemfile_path_backup = @gemfile_path + "-backup-#{self.class.datetime_string}"
      FileUtils.copy_file(@gemfile_path, @gemfile_path_backup)
      @gemfile_path_backup
    end

    def build_meta_gemfile
      parser = AnnotateGemfile::Parser.parse(@gemfile_path)
      @meta_gemfile = parser.gemfile_meta
      @meta_gemfile.collect! do |line|
        if line[:source].class != Bundler::Source::Path
          line.merge( {:rubygem_info => self.class.gem_info(line[:name])} )
        else
          line
        end
      end
      @gemfile_array = parser.gemfile_array
    end

    def populate_github_metadata
    end

  end

end
