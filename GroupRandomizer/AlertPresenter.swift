//
//  AlertPresenter.swift
//  GroupRandomizer
//
//  Created by Stepan Baranov on 12.10.2023.
//

import UIKit

class AlertPresenter {
    weak var onViewController: ViewController?
    
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Attention!",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(action)
        onViewController?.present(alert, animated: true, completion: nil)
    }
    
    init(onViewController: ViewController) {
        self.onViewController = onViewController
    }
}
