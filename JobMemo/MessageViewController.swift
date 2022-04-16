//
//  MessageViewController.swift
//  JobMemo
//
//  Created by Yao Zhang on 4/9/22.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var message : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = message
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pop(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }//pop
    
    @IBAction func copyMessage(_ sender: Any) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = message
        let alertController = UIAlertController(title: "Text Copied", message:
                "Message successfully copied to clipboard!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
    }//pop
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
