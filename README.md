# Simple Bitwarden Workflow for Alfred

Simple yet powerful integration with the Bitwarden CLI so you can now get your passwords out of your Bitwarden vault and straight into the clipboard from within Alfred.

##Version 1.0.0 update - Please Read

-----

Ladies and gents, I am happy to present v1.0.0 of the workflow. Before I continue, this workflow has not been developed from scratch. The LastPass CLI workflow was the start and was remodeled to fit the Bitwarden CLI. Nonetheless it was a SIGNIFICANT amount of work for me so if you like it and use it, please say thank you by donating towards my organic food. Any amount will do, whatever you feel the value is for you/your business/your time :)

I have never used LastPass, I prefer to selfhost my applications. From the day I heard about Bitwarden I loved it - that was at the beginning of this year (2018).

If you haven't used Bitwarden before... you are crazy and you should! Say bye to LastPass and hello to selfhosting. It is the single greatest password manager package out there :D so check it out at [https://bitwarden.com](https://bitwarden.com).

-----

## Donations
This workflow represents many many hours effort of development and testing. So if you love the workflow, and get use out of it every day, if you would like to donate as a thank you to buy me some healthy organic food (or organic coffee), or to put towards a shiny new gadget you can [donate to me via Paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=K7BXYQ3SQ76J6). 

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=K7BXYQ3SQ76J6" target="_blank"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" border="0" alt="PayPal — The safer, easier way to pay online."></a>


## Installation

1. Ensure you have Alfred installed with the Alfred Powerpack License
3. Install Homebrew (if you do not have it already installed)
	1. You should be able to just run the command in a terminal window (as your own user account NOT with sudo)
	2. ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	3. Alternatively visit http://brew.sh/ for further instructions.
4. Install Bitwarden CLI command line interface
	1. In a terminal window run
		brew install bitwarden-cli
5. Download the .alfredworkflow file
6. Open the .alfredworkflow file to import into Alfred
7. Run 'bwsetemail yourloginemail@yourdomain.com' in Alfred to set your Bitwarden username.
8. Run 'bwsetserver https://bitwarden.example.com' in Alfred to set your Bitwarden URL. (optional, default uses https://bitwarden.com)

## Usage

* bwsetemail yourname@example.com - must be run when you first install/upgrade to version 1.0 or higher
* bwlogin - Log in to Bitwarden
* bwlogout - Log out of Bitwarden
* bwunlock - Unlock the Bitwarden vault in case in case it is locked
* bw <query> Search Bitwarden vault for item containing <query>, press return to copy the password to clipboard.
* Shift modifier can be used on bw <query> to copy the username.
* Alt modifier can be used on bw <query> to copy the totp (if available).

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

* Version 1.0 - Initial Release

## Credits

Created by [Claas Lisowski](https://lisowski-development.com). If you would like to get into contact you can do so via:
* [@blacs30 on Twitter](http://twitter.com/blacs30)
* [Claas Lisowski on LinkedIn](https://www.linkedin.com/in/claas-fridtjof-lisowski-558220b7/)

## License

Released under the GNU GENERAL PUBLIC LICENSE Version 2, June 1991

## Notes
NOTE: This Alfred Workflow is not affiliated in any way with Bitwarden. The Bitwarden trademark and logo are owned by Bitwarden.com. The Bitwarden logo and product name have been used with permission of the Bitwarden team.

My thanks go out to Bitwarden for their awesome product and the new CLI!
