//
//  AddViewController.swift
//  Remainders
//
//  Created by Yuvraj Vijay Agarkar on 26/10/20.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet var titleField:UITextField!
    @IBOutlet var bodyField:UITextField!
    @IBOutlet var datePicker:UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bodyField.delegate = self
        titleField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: target, action: #selector(didTapSaveButton))
        // Do any additional setup after loading the view.
    }
    
     @objc func didTapSaveButton(){
        if let titleText = titleField.text , !titleText.isEmpty ,let bodyText = bodyField.text , !bodyText.isEmpty {
            let targetDate = datePicker.date
//            var arry:[Any] = [titleText,bodyText,targetDate]
            NotificationCenter.default.post(name: name, object: nil, userInfo: ["title"  : titleText,"body":bodyText,"date":targetDate])
            navigationController?.popToRootViewController(animated: true)
        }
    }

}
extension AddViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        bodyField.resignFirstResponder()
        return true
    }
}
