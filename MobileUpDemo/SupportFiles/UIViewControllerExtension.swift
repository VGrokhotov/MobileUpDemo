//
//  UIViewControllerExtension.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 24.07.2021.
//

import UIKit
import Localizer

extension UIViewController {
    
    //MARK: Alerts
    
    func createOkAction(action: Optional<() -> ()> = nil) -> UIAlertAction {
        let okString = String(.en("Ok"), .ru("Ок"))
        if let action = action {
            return UIAlertAction(title: okString, style: .default) { _ in
                action()
            }
        } else {
            return UIAlertAction(title: okString, style: .default)
        }
    }
    
    func alert(title: String, message: String, action:  Optional<() -> ()> = nil) {
        
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = createOkAction(action: action)
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    func errorAlert(title: String, message: String, retryAction: Optional<() -> ()> = nil, okAction: Optional<() -> ()> = nil ){
        
        let allert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let action = retryAction {
            
            let retryAction = UIAlertAction(title: String(.en("Retry"), .ru("Попробовать еще")), style: .default) { _ in
                action()
            }
            
            let cancelAction = UIAlertAction(title: String(.en("Cancel"), .ru("Отмена")), style: .cancel)
            
            allert.addAction(retryAction)
            allert.addAction(cancelAction)
            
        } else {
            let okAction = createOkAction(action: okAction)
            allert.addAction(okAction)
        }
        
        
        present(allert, animated: true)
    }
    
    func showError() {
        errorAlert(
            title: String(.en("Error occurred!"), .ru("Произошла ошибка!")),
            message: String(.en("Contact the developer for help."), .ru("Обратитесь к разработчику за помощью.")),
            retryAction: nil) {
            self.dismiss(animated: true)
        }
    }
}
