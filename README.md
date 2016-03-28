# PhoneNumberPicker
A simple and easy to use view controller enabling you to enter a phone number with a country code similar to WhatsApp

Screenshots
--------------
![alt text](https://github.com/hughbe/PhoneNumberPicker/blob/master/resources/screenshots/1.png "Screenshot 1")
![alt text](https://github.com/hughbe/PhoneNumberPicker/blob/master/resources/screenshots/2.png "Screenshot 2")

Installation
--------------
Drag and drop the *src* folder to your project

Setup
--------------
``` swift
// 1. Add the protocol PhoneNumberViewControllerDelegate
class ViewController: UIViewController,PhoneNumberViewControllerDelegate {


func presentPhoneNumberViewController { //Your function. Can be any name
   // 2. Create the PhoneNumberViewController
   let phoneNumberViewController = PhoneNumberViewController.standardController()

   // 3. Set the delegate
   phoneNumberViewController.delegate = self

   // 4. Present the PhoneNumberViewController (Navigation Controller)
   navigationController?.pushViewController(phoneNumberViewController, animated: true)
}
```

Country Selector
-------------
You can manually present a `CountriesViewController` to present a list of all countries and their phone extensions to the user
