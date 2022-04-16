//
//  EditViewController.swift
//  JobMemo
//
//  Created by Yao Zhang on 4/7/22.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var salary: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var skills: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var status: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var edit: UIBarButtonItem!
    var first = true
    var message = ""
    var prevVC =  JobsTableViewController()
    var jobListing : JobListing? = nil
    var loc = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobListing = prevVC.jobListingList[loc]
        if let j = jobListing {
            skills.text = j.skills
            position.text = j.position
            if(j.salary != -1) {salary.text = String(j.salary)}
            website.text = j.website
            navigation.title = j.company
            dateTextField.text = j.date
            let color = j.color
            switch(color){
            case "Blue":
                imageView.tintColor = .systemBlue
                break
            case "Red":
                imageView.tintColor = .systemRed
                break
            case "Orange":
                imageView.tintColor = .systemOrange
                break
            case "Green":
                imageView.tintColor = .systemGreen
                break
            case "Yellow":
                imageView.tintColor = .systemYellow
                break
            case "Purple":
                imageView.tintColor = .systemPurple
                break
            default:
                imageView.tintColor = .systemBlue
            }
            status.selectedSegmentIndex = Int(j.status)
            updateStatus(status)
        }
        position.isUserInteractionEnabled = false
        website.isUserInteractionEnabled = false
        dateTextField.isUserInteractionEnabled = false
        status.isUserInteractionEnabled = false
        salary.isUserInteractionEnabled = false
        skills.isUserInteractionEnabled = false
        position.backgroundColor = UIColor.tertiarySystemBackground
        website.backgroundColor = UIColor.tertiarySystemBackground
        dateTextField.backgroundColor = UIColor.tertiarySystemBackground
        salary.backgroundColor = UIColor.tertiarySystemBackground
        skills.backgroundColor = UIColor.tertiarySystemBackground
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(AddViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        dateTextField.inputView = datePicker
        
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
    
    func save() {
        if let context = (UIApplication.shared.delegate as?AppDelegate)?.persistentContainer.viewContext{
            
            
            let edited = JobListing(entity: JobListing.entity(), insertInto: context)
            edited.color = jobListing?.color
            edited.company = jobListing?.company
            edited.position = jobListing?.position
            edited.skills = jobListing?.skills
            if(dateTextField.text != "" && dateTextField.text != nil) {edited.date = dateTextField.text}
            edited.status = Int16(status.selectedSegmentIndex)
            if(website.text != "" && website.text != nil) {edited.website = website.text}
            if(salary.text != "" && salary.text != nil) {edited.salary = Double(salary.text!)!}
            else{edited.salary = -1}
            context.delete(jobListing!)
            jobListing = edited
            try? context.save()
           
            navigationController?.popViewController(animated: true)
        }
    }
     
    
    @IBAction func visitURL(_ sender: UIButton) {
        if let j = jobListing {
            if(j.website != nil)
            {
                if(URL(string: j.website!) != nil){
                if UIApplication.shared.canOpenURL(URL(string: j.website!)!) {
                    UIApplication.shared.open (URL(string: j.website!)!)
                    return
                }
                }
            }
            let alertController = UIAlertController(title: "Alert", message:
                    "No valid URL found!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
            return
            
        
        }
    }
    
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
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        if (edit.title == "Edit")
        {
            edit.title = "Save"
            website.isUserInteractionEnabled = true
            dateTextField.isUserInteractionEnabled = true
            status.isUserInteractionEnabled = true
            salary.isUserInteractionEnabled = true
            
            website.backgroundColor = UIColor.systemGray5
            dateTextField.backgroundColor = UIColor.systemGray5
            salary.backgroundColor = UIColor.systemGray5
            
        }
        else{
            save()
        }
    }
    
    @IBAction func message(_ sender: UIButton) {
        if let j = jobListing {
            if (j.company != nil && j.position != nil && j.skills != nil)
            {
                message = "Dear " + j.company! + ", I am interested in your " + j.position! + " position, I have strong skills in " + j.skills! + ". Please take a look at my resume attached below."

                self.performSegue(withIdentifier: "message", sender: self)
                
            }
        
        }
    }
    @IBAction func share(_ sender: UIButton){
        var builder = ""
        builder += "Company Name: " + (jobListing?.company)! + "\n"
        builder += "Position: " + (jobListing?.position)! + "\n"
        if(jobListing?.salary != -1)
        {
            builder += "Compensation: " + String(jobListing!.salary) + "\n"
        }
        else{
            builder += "Compensation: " + "N/A" + "\n"
        }
        builder += "Skills Needed: " + (jobListing?.skills)! + "\n"
        if(jobListing?.website != "" && jobListing?.website != nil)
        {
            builder += "Website: " + (jobListing?.website)! + "\n"
        }
        else{
            builder += "Website: " + "N/A" + "\n"
        }
        if(jobListing?.date != "" && jobListing?.date != nil)
        {
            builder += "Due Date: " + (jobListing?.date)! + "\n"
        }
        else{
            builder += "Due Date: " + "N/A" + "\n"
        }
        var s = ""
        switch(status.selectedSegmentIndex){
        case 0:
            s = "Not Applied"
            break
        case 1:
            s = "Applied"
            break
        case 2:
            s = "Interviewing"
            break
        case 3:
            s = "Decision Made"
            break
        default:
            s = "Not Applied"
            break
        }
        builder += "Status: " + s + "\n"
        let textToShare = [ builder ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "message") {

            let VC = (segue.destination as! MessageViewController)
            VC.message = message
        }
    }
    
    
}
