//
//  ViewController.swift
//  PhoneNumberPickerExample
//
//  Created by Lucas Farah on 3/28/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import UIKit

class ViewController: UIViewController,PhoneNumberViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let but = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        but.setTitle("Phone Number", for: [])
        but.setTitleColor(UIColor.black, for: [])
        but.addTarget(self, action: #selector(ViewController.showView), for: .touchUpInside)
        view.addSubview(but)
    }

    @objc func showView() {
        let phoneNumberViewController = PhoneNumberViewController.standardController()
        phoneNumberViewController.delegate = self
        navigationController?.pushViewController(phoneNumberViewController, animated: true)
    }

    func phoneNumberViewControllerDidCancel(phoneNumberViewController: PhoneNumberViewController) {
        self.navigationController?.popViewController(animated: true)
        print("canceled")
    }

    func phoneNumberViewController(phoneNumberViewController: PhoneNumberViewController, didEnterPhoneNumber phoneNumber: String) {
        self.navigationController?.popViewController(animated: true)
        print("phone number: \(phoneNumber)")
    }
}
