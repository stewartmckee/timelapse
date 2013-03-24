#require "timelapse/version"
require 'rufus/scheduler'
require 'gphoto4ruby'

module Timelapse
  class Session

    def start(options={})
      begin
        options[:interval] = "30s" unless options.has_key?(:interval)
        save_options = {:to_folder => options[:output]} if options.has_key?(:output)
        puts "Connecting to camera..."
        camera = GPhoto2::Camera.new
        puts "Using #{camera.model_name}"
        puts "Interval: #{options[:interval]}"
        puts "Output: #{options[:output]}" if options[:output]
        scheduler = Rufus::Scheduler.start_new
        scheduler.every options[:interval] do
          puts "Taking picture..."
          camera.capture.save(save_options).delete
          puts "Saved."
        end
        scheduler.join
      rescue => e
        puts e
      ensure
        camera.dispose
      end
    end
  end
end
