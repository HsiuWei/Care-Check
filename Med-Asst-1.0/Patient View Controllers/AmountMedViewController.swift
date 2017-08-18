//
//  AmountMedViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 15/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit

class AmountMedViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var catchMed: Medicine?
    
    var pillAmountInt: Int = 1
    var timePeriodInt: Int = 1
    var noteText: String?
    
    @IBOutlet weak var nextButtonView: UIButton!
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    @IBOutlet weak var pillAmountPicker: UIPickerView!
    @IBOutlet weak var timePeriodPicker: UIPickerView!
    
    let options = ["1","2","3","4","5"]
    
    @IBOutlet weak var noteTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiDesign()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AmountMedViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //1 row needed only
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pillAmountPicker {
            
            pillAmountInt = Int(options[row])!
           
            
        }
            
        else {
            
            timePeriodInt = Int(options[row])!
            
        }
    }
    
  

    
    @IBAction func nextButtonTappedAmount(_ sender: Any) {
        
        performSegue(withIdentifier: "toConfirmationView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmationView" {

            noteText = noteTextField.text
            
            let finalMed = Medicine(name: (catchMed?.name)!, nickname: (catchMed?.nickname)!, fromDate: (catchMed?.fromDate)!, toDate: (catchMed?.toDate)!, amount: pillAmountInt, frequency: timePeriodInt, unit: noteText!)
                
            let confirmVC = segue.destination as? ConfirmationViewController
            confirmVC?.catchMed = finalMed

        }
    }
    
    
    func uiDesign() {
        
        
        
        self.nextButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.nextButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.nextButtonView.layer.shadowOpacity = 0.8
        self.nextButtonView.layer.shadowRadius = 10.0
        self.nextButtonView.layer.masksToBounds = false

        HomeBackgroundView.clipsToBounds = true
        HomeBackgroundView.isHidden = false
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)

        
        
        
    }
    
    @IBAction func unwindToAmount(_ segue: UIStoryboardSegue) {
    }


}
