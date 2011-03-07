# modified from http://stackoverflow.com/questions/2562249/how-can-i-set-paperclips-storage-mechanism-based-on-the-current-rails-environmen/2568705#2568705
module PaperclipWrapper
  class << self
    def included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def has_attachment(name, options = {})
      # generates a string containing the singular model name and the pluralized attachment name.
      # Examples: "item-photos", "user-avatars" or "asset-uploads"
      attachment_owner    = self.table_name.singularize
      attachment_folder   = "#{attachment_owner}-#{name.to_s.pluralize}"

      # we want to create a path for the upload that looks like:
      # item-photos/4-originalfilename-medium.jpg
      attachment_path     = "#{attachment_folder}/:id-:basename-:style.:extension"
      
      # YML file containing S3 credentials (see s3.yml.example for more info)
      s3_yml_file = Rails.root.join("config", "s3.yml")

      if Rails.env.production? || File.exists?(s3_yml_file)
        options[:path]            ||= attachment_path
        options[:storage]         ||= :s3
        
        if File.exists?(s3_yml_file)
          options[:s3_credentials]  ||= s3_yml_file
        else
          options[:s3_credentials]  ||= S3_CREDENTIALS # take settings from s3.rb initializer
        end
        
        # options[:url]             ||= ':s3_authenticated_url'
        # options[:s3_permissions]  ||= 'private'
        # options[:s3_protocol]     ||= 'https'
      else
        # For local Dev/Test envs, use the default filesystem, but separate the environments
        # into different folders, so you can delete test files without breaking dev files.
        options[:path]  ||= ":rails_root/public/system/attachments/#{Rails.env}/#{attachment_path}"
        options[:url]   ||= "/system/attachments/#{Rails.env}/#{attachment_path}"
      end

      # pass things off to paperclip.
      has_attached_file name, options
    end
  end
end
