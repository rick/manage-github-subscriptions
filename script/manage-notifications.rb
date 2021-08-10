#!/usr/bin/env ruby

require "octokit"
require "yaml"
require "pp"

# should debugging output be enabled?
def debugging?
  ENV['DEBUG'] && ENV['DEBUG'] != ''
end

# retrieve all current subscriptions
def current_subscribed_repositories(client)
  client.auto_paginate = true
  puts "Retrieving current subscriptions..."
  watched_repos = client.subscriptions.map {|r| r[:full_name] }
end

# which repositories do we *want* to be subscribed to?
def desired_repositories
  File.readlines(File.expand_path('~/.github/subscribed-repos.txt')).each do |line|
    line.chomp!
  end
end

# retrieve GitHub API token
creds = YAML.load(File.read(File.expand_path('~/.github.yml')))
access_token = creds["token"]

# which repositories do we *want* to be subscribed to?
allowed = desired_repositories

client = Octokit::Client.new :access_token => access_token
puts "Current octokit rate limit: #{client.rate_limit.inspect}" if debugging?

current_names = current_subscribed_repositories client
puts "watching [#{current_names.size}] repos"

puts current_names.sort

# find subscriptions to add and remove
to_delete = current_names - allowed
to_add = allowed - current_names

puts "deleting #{to_delete.size} repository subscriptions..."

to_delete.sort.each do |repo|
  puts "Unsubscribing from [#{repo}]..."
  client.delete_subscription repo
end

puts "adding #{to_add.size} repository subscriptions..."
to_add.sort.each do |repo|
  puts "Subscribing to [#{repo}]"
  client.update_subscription(repo, { subscribed: true })
end
