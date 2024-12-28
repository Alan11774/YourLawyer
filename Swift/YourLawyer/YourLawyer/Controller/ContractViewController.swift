//
//  ContractViewController.swift
//  YourLawyer
//
//  Created by Alan Ulises on 28/12/24.
//

import UIKit

class ContractViewController: UIViewController {
    
    var lawyer: Lawyer?

    override func viewDidLoad() {
        super.viewDidLoad()
        lawyer = LawyerManager.shared.selectedLawyer
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

}
