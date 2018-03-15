//
//  ViewController.swift
//  GeoCode
//
//  Created by Backlin,Gene on 3/14/18.
//  Copyright © 2018 Backlin,Gene. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var zipcodeTextField: UITextField!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayMap" {
            let controller: MapViewController = segue.destination as! MapViewController
            controller.zipcode = zipcodeTextField.text
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "DisplayMap", sender: self)
        
        return true
    }
}
