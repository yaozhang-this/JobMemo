//
//  JobsTableViewController.swift
//  JobMemo
//
//  Created by Yao Zhang on 4/7/22.
//

import UIKit
import CoreData

class JobsTableViewController: UITableViewController {

    var jobListingList :[JobListing] = []
    var loc = 0
    var selected = "all"
    @IBOutlet weak var filter: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let showAll = UIAction(title: "Show All", state: .on, handler: { [self] _ in
            self.selected = "all"
            filter.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
            getJobListings(mode: selected)
             })
        let showNotApplied = UIAction(title: "Show Not Applied", handler: { [self] _ in
            self.selected = "notApplied"
            filter.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
            getJobListings(mode: selected)
             })
        let showApplied = UIAction(title: "Show Applied", handler: { [self] _ in
            self.selected = "applied"
            filter.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
            getJobListings(mode: selected)
             })
        let showInterviewing = UIAction(title: "Show Interviewing", handler: { [self] _ in
            self.selected = "interviewing"
            filter.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
            getJobListings(mode: selected)
             })
        let showDecision = UIAction(title: "Show Decision", handler: { [self] _ in
            self.selected = "decision"
            filter.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
            getJobListings(mode: selected)
             })
        let buttonMenu = UIMenu(title: "Filter", children: [showAll, showNotApplied, showApplied, showInterviewing, showDecision])
        filter.menu = buttonMenu
        
        filter.changesSelectionAsPrimaryAction = true
        filter.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        
        
        getJobListings(mode: selected)
    } //viewDidLoad

    
    
    // MARK: - Table view data source
    func getJobListings(mode: String) {
        if let context = (UIApplication.shared.delegate as?AppDelegate)?.persistentContainer.viewContext{
            if let coreDataJobListing =  try? context.fetch(JobListing.fetchRequest()) as?
                [JobListing] {
                jobListingList = coreDataJobListing
                var temp :[JobListing] = []
                if(mode != "all")
                {
                for j in jobListingList{
                    switch (mode){
                    case "notApplied":
                        if (j.status == 0)
                        {
                            temp.append(j)
                        }
                        break
                    case "applied":
                        if (j.status == 1)
                        {
                            temp.append(j)
                        }
                        break
                    case "interviewing":
                        if (j.status == 2)
                        {
                            temp.append(j)
                        }
                        break
                    case "decision":
                        if (j.status == 3)
                        {
                            temp.append(j)
                        }
                        break
                    default:
                        break
                    
                }
                }

                jobListingList = temp
                }
                
                
                tableView.reloadData()
            }
        }
        
    }//getJobListings()
    
    override func viewWillAppear(_ animated: Bool) {
        getJobListings(mode: selected)
        
    }//viewWillAppear

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobListingList.count
    }//numberOfRowsInSection

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Display a job listing as "company, position" for each cell in the table
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let thisCompany = jobListingList[indexPath.row].company
        let thisPosition = jobListingList[indexPath.row].position
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = thisCompany! + "\n" + thisPosition!
        cell.imageView?.image = UIImage(systemName: "tag.fill")
        switch(jobListingList[indexPath.row].color)
        {
        case "Blue":
            cell.imageView?.tintColor = .systemBlue
            break
        case "Green":
            cell.imageView?.tintColor = .systemGreen
            break
        case "Orange":
            cell.imageView?.tintColor = .systemOrange
            break
        case "Red":
            cell.imageView?.tintColor = .systemRed
            break
        case "Purple":
            cell.imageView?.tintColor = .systemPurple
            break
        case "Yellow":
            cell.imageView?.tintColor = .systemYellow
            break
        default:
            cell.imageView?.tintColor = .systemBlue
        }
        return cell
    }//cellForRowAt
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loc = indexPath.row
        performSegue(withIdentifier: "editSegue", sender: jobListingList[indexPath.row])
    }//didSelectRowAt
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let jobListing = jobListingList[indexPath.row]
            //tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as?AppDelegate)?.persistentContainer.viewContext{
                context.delete(jobListing)
                try? context.save()
                getJobListings(mode: selected)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }//commit editingStyle:
    
    
    // FIX - uncomment and edit the follow code block after implementing AddViewController and EditViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editSegue") {
            let editVC = (segue.destination as! EditViewController)
                let todo = sender as! JobListing
                editVC.jobListing = todo
                editVC.loc = loc
                editVC.prevVC = self
        }
        if(segue.identifier == "addSegue") {
            let editVC = (segue.destination as! AddViewController)
                editVC.prevVC = self
        }
        
    }
    
    
    

    
    
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//JobsTableViewController class
