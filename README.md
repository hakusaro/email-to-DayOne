# ETD: Email -> Day One

I told someone that I would build an Android client for Day One once. This is a much easier solution to deal with.

## Features

_Features that are italicized are not implemented yet._

* _Emails sent to a specified address are read and imported into Day One._
	* _If an image is attached, that image's EXIF data will be read for location information._
	* _If an image is attached, that image will become that entry's image._
	* _If hashtags are present in the subject line, those hashtags will become native tags in Day One._

As of right now, the subject line will serve no real purpose -- Day One does not have an "entry title" by default, but supports one if the first line of the entry is a title.

## Suggestions & improvements

As soon as there's some code here, a pull request is fine!

## License

GPL v3.0

## Disclaimer

It's not my responsibility if your Day One journal becomes corrupted. It shouldn't -- this uses the command line tools it comes with, but if it does, it's not my problem. It would be highly advisable to setup backup in Day One -> Preferences before going setting this up.