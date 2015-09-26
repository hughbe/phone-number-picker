# PhoneNumberPicker
A simple and easy to use view controller enabling you to enter a phone number with a country code similar to WhatsApp

Screenshots
--------------
![alt text](https://github.com/hughbe/PhoneNumberPicker/blob/master/resources/screenshots/1.png "Screenshot 1")
![alt text](https://github.com/hughbe/PhoneNumberPicker/blob/master/resources/screenshots/2.png "Screenshot 2")

Setup
--------------
- 1: Create the PhoneNumberViewController
	`let phoneNumberViewController = PhoneNumberViewController.standardController()`
- 2: Set delegate (optional)
	`phoneNumberViewController.delegate = self`
- 3: Present the PhoneNumberViewController (Modally)
	`presentViewController(phoneNumberViewController, animated: true, completion: nil)`
- 4: Present the PhoneNumberViewController (Navigation Controller)
	`phoneNumberViewController.cancelBarButtonItemHidden = true`
	`navigationController?.pushViewController(phoneNumberViewController, animated: true)`


Delegate
--------------
You can respond to delegate methods using the `PhoneNumberViewControllerDelegate` protocol

Country Selector
-------------
You can manually present a `CountriesViewController` to present a list of all countries and their phone extensions to the user
