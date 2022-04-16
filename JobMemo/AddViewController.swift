//
//  AddViewController.swift
//  JobMemo
//
//  Created by Yao Zhang on 4/7/22.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var companyTitle: UITextField!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var skills: UITextField!
    @IBOutlet weak var tag: UITextField!
    @IBOutlet weak var status: UISegmentedControl!
    var colors = ["Blue", "Green", "Yellow", "Orange", "Red", "Purple"]
    var prevVC = JobsTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0.25
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(AddViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        dateTextField.inputView = datePicker
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        tag.inputView = picker
        
        // Do any additional setup after loading the view.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = formatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    @IBAction func save(_ sender: Any) {
        
        if(companyTitle.text == "" || position.text == "" || skills.text == "")
        {
            let alertController = UIAlertController(title: "Alert", message:
                    "Required fields can not be empty!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
            return
        }
        if let context = (UIApplication.shared.delegate as?AppDelegate)?.persistentContainer.viewContext{
            
            let jobListing = JobListing(entity: JobListing.entity(), insertInto: context)
            
            if let company = companyTitle.text {
                jobListing.company = company
                jobListing.position = position.text
                if(salary.text != "") {jobListing.salary = Double(salary.text!)!}
                else{jobListing.salary = -1}
                jobListing.website = website.text
                jobListing.skills = skills.text
                jobListing.date = dateTextField.text
                jobListing.status = Int16(status.selectedSegmentIndex)
                if(tag.text != "") {jobListing.color = tag.text}
                else{jobListing.color = "Blue"}
            
            }
            try? context.save()
            prevVC.getJobListings(mode: "all")
            self.dismiss(animated: true, completion: nil)
        }
    }//save
    
    @IBAction func pop(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }//pop
    
    @IBAction func updateStatus(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            progress.progress = 0.25
        }
        else if(sender.selectedSegmentIndex == 1){
            progress.progress = 0.50
        }
        else if(sender.selectedSegmentIndex == 2){
            progress.progress = 0.75
        }
        else{
            progress.progress = 1
        }
            
    }
    
}

extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tag.text = colors[row]
        
    }
}
