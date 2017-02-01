# ETD: Email -> Day One

I told someone that I would build an Android client for Day One once. This is a much easier solution to deal with.

**Please don't use this.** Day One 2.0 has IFTTT support that's 100x better than using this script. It's faster, easier, and much, much better to setup.

### Features

_Features that are italicized are not implemented yet._

* Emails sent to a specified address are read and imported into Day One.
	* If an image is attached, that image's EXIF data will be read for location information.
	* If an image is attached, that image will become that entry's image.
	* If hashtags are present in the subject line, those hashtags will become native tags in Day One.

As of right now, the subject line will serve no real purpose -- Day One does not have an "entry title" by default, but supports one if the first line of the entry is a title.

### Installation

Installing this script requires basic knowledge of how to setup a ruby script.

1. ````git clone https://github.com/nicatronTg/email-to-DayOne.git````
2. ````cd email-to-DayOne````
3. Assuming you have [rvm](http://rvm.io/) setup, you should automatically be informed about using Ruby 2.0. If not, setup RVM. It may be necessary to run ````rvm install 2.0```` if you have never used Ruby 2.0 before.
4. ````bundle install````
5. ````cp config.yaml.example config.yaml````
6. Set the config options to the mailbox you wish to take emails from and use in your journal. Create an IMAP folder (or Gmail label) for your journal entries and set that here. __DO NOT SET THIS TO YOUR INBOX. YOU WILL DELETE YOUR INBOX'S MAIL IF YOU AREN'T CAREFUL.__ Processing count refers to the number of entries to process per script run.
7. Make a folder to temporarily hold images. Then, change ````config.yaml````'s image_path setting to that location (with a trailing slash, please).
8. Run the script. ````ruby app.rb```` If any errors happen, check to make sure your configuration options are sane. If you're using Gmail, you may need to enable IMAP in your Gmail settings before this will be able to access it.

At this point, you may wish to setup automation of some kind to run this on a regular basis. In addition, you should configure appropriate filters in your email client to allow you to put your desired emails into the appropriate mailbox and out of the inbox.

### Suggestions & improvements

Send pull requests & the usual to this repository.

### License

GPL v3.0

### Disclaimer

It's not my responsibility if your Day One journal becomes corrupted. It shouldn't -- this uses the command line tools it comes with, but if it does, it's not my problem. It would be highly advisable to setup backup in ````Day One -> Preferences```` before going setting this up.

This script may or may not permanently delete email, depending on your server's IMAP settings. By default, on Gmail, IMAP will only archive the messages it gets, not delete them. If an entry is malformed and you attempt to run this script, it may delete the email without warning and without adding it to Day One (this is due to a limitation with the mail library used -- which only supports deleting messages with the find and delete method).
