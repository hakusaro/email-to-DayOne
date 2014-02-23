#coding: utf-8

require 'mail'
require 'rb-dayone'

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

	if (msg.has_attachments?) then
		#todo: extract image and also location data using some crazy image library
	end

	journal_entry = DayOne::Entry.new(entry_body, :creation_date => entry_date)
	if entry_tags != nil && !entry_tags.empty? then journal_entry.tags = entry_tags end
	
	# Create the journal entry, and mark the email for deletion
	journal_entry.create!
end