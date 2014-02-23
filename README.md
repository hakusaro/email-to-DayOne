# ETD: Email -> Day One

## Features

_Features that are italicized are not implemented yet._

* Emails sent to a specified address are read and imported into Day One.
	* If an image is attached, that image's EXIF data will be read for location information.
	* If an image is attached, that image will become that entry's image
	* If hashtags are present in the subject line, those hashtags will become native tags in Day One.

As of right now, the subject line will serve no real purpose -- Day One does not have an "entry title" by default, but supports one if the first line of the entry is a title.

## Suggestions & improvements

As soon as there's some code here, a pull request is fine!

## License

GPL v3.0

## Disclaimer

It's not my responsibility if your Day One journal becomes corrupted. It shouldn't -- this uses the command line tools it comes with, but if it does, it's not my problem. It would be highly advisable to setup backup in Day One -> Preferences before going setting this up.