require 'spec_helper'
require "rake"

describe "cron rake tasks" do
  before do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "lib/tasks/cron"
    Rake::Task.define_task(:environment)
  end

   describe "User" do
			it "should have a published named scope that returns articles with published flag set to true" do
        #Add test
			end
		end

end
