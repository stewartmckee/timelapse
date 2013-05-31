#require "timelapse/version"
require 'rufus/scheduler'
require 'gphoto4ruby'
require 'aws/s3'
require 'net/ftp'

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
          puts "Saved to disk."
          filename = "LICENSE.txt"
          puts options
          if options[:s3_bucket]
            s3 = AWS::S3::Base.establish_connection!(
              :access_key_id     => options[:s3_access_key], 
              :secret_access_key => options[:s3_secret_key]
            )
            AWS::S3::Bucket.create(options[:s3_bucket])
            AWS::S3::S3Object.store(filename, open(filename), options[:s3_bucket])

            puts "Uploaded to S3."
          end

          if options[:ftp_server]
            ftp = Net::FTP.new(options[:ftp_server])
            ftp.login(options[:ftp_user], options[:ftp_password])
            puts ftp.pwd()
            ftp.chdir(options[:ftp_path]) if options[:ftp_path]
            ftp.storbinary('STOR', filename, open(filename))
            ftp.close
            puts "Uploaded to FTP."
          end

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
