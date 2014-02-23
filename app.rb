#coding: utf-8

require 'mail'
require 'rb-dayone'
require 'exifr'

temp_config = ""
File.open('config.yaml', 'r').each_line do |line|
  temp_config << line
end
app_config = YAML.load(temp_config)

Mail.defaults do
  retriever_method :imap, :address    => app_config['imap_server'],
                          :port       => app_config['imap_port'],
                          :user_name  => app_config['imap_username'],
                          :password   => app_config['imap_password'],
                          :enable_ssl => app_config['use_ssl']
end

emails = Mail.find_and_delete(:what => :last, :mailbox => app_config['folder'], 
	:count => app_config['processing_count'])

emails.each do |msg|
	
	# Emails might be multipart, in which case, we would prefer the text only version...
	entry_body = nil
	if (msg.multipart?) then
		entry_body = msg.text_part.body
	else
		entry_body = msg.body
	end

	# Use the email date as the entry date...
	entry_date = Time.parse(msg.date.to_s)

	# If there is a subject to the email
	if (msg.subject != nil) then
		# Remove non-hashtags from the tag list
		entry_tags = msg.subject.split(' ').delete_if do |tag|
			if !tag.include? '#' then true else false end
		end

		# Remove the hashtag from each hashtag
		entry_tags.each do |tag|
			tag.delete!('#')
		end
	end

	entry_image_file_location = nil

	# extract the image from the attachments list
	# technically this will grab every attached image and only use the last one, but...
	if (msg.has_attachments?) then
		msg.attachments.each do | attachment |
		  if (attachment.content_type.start_with?('image/'))
		    filename = attachment.filename
		    begin
		      File.open(app_config['images_folder'] + filename, "w+b", 0644) {|f| f.write attachment.body.decoded}
		      entry_image_file_location = app_config['images_folder'] + filename
		    rescue => e
		      puts "Unable to save data for #{filename} because #{e.message}"
		    end
		  end
		end
	end

	journal_entry = DayOne::Entry.new(entry_body, :creation_date => entry_date)
	
	# Add the tags to the entry
	if entry_tags != nil && !entry_tags.empty? then journal_entry.tags = entry_tags end
	
	# If we have an image
	if (entry_image_file_location != nil) then
		journal_entry.image= entry_image_file_location # add the image to the entry
		
		if ((entry_image_file_location.downcase.include? 'jpeg') || (entry_image_file_location.downcase.include? 'jpg')) then
			exifdata = EXIFR::JPEG.new(entry_image_file_location)
			if (exifdata.gps != nil && exifdata.gps.latitude != nil && exifdata.gps.longitude != nil) then
				entry_location = DayOne::Location.new
				entry_location.latitude = exifdata.gps.latitude
				entry_location.longitude = exifdata.gps.longitude
				journal_entry.location = entry_location # add location data if available from the image to the entry
			end
		end
	end

	# Create the journal entry, and mark the email for deletion
	journal_entry.create!
	File.delete(entry_image_file_location) # delete the temporary image we wrote earlier
end