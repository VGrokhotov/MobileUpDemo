//
//  MainVC.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 21.07.2021.
//

import UIKit
import Localizer

class MainVC: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        present(AuthVC(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureButton()
    }
    
    func configureButton() {
        enterButton.layer.cornerRadius = 10
        enterButton.clipsToBounds = true
        enterButton.setTitle(String(.en("Enter via VK"), .ru("Вход через VK")), for: .normal)
    }
}
