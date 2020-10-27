//
//  AlertManager.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/04.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit

struct AlertManager {
   
    /// 閉じるボタンが付いたアラート
    func alertAction(viewController:UIViewController, title: String, message: String, didTapButton: @escaping (UIAlertAction) -> ()){
        let controller:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .default,
                                           handler: didTapButton)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    /// 「削除」、「閉じる」が付いたアラート
    func alertDeleteAction(viewController:UIViewController, title: String?, message: String,  deleteButton: String = "削除", closeButton: String = "閉じる", didTapDeleteButton: @escaping (UIAlertAction)->(),didTapCloseButton: @escaping (UIAlertAction) -> ()){
        let controller:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: deleteButton,
                                           style: .destructive,
                                           handler: didTapDeleteButton)
        )
        
        controller.addAction(UIAlertAction(title: closeButton,
                                           style: .default,
                                           handler: didTapCloseButton)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    /// 「はい」、「いいえ」が付いたアラート
    func alertAction(viewController:UIViewController, title: String?, message: String, didTapYesButton: @escaping (UIAlertAction)->(),didTapNoButton: @escaping (UIAlertAction) -> ()){
        let controller:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "はい",
                                           style: .default,
                                           handler: didTapYesButton)
        )
        
        controller.addAction(UIAlertAction(title: "いいえ",
                                           style: .cancel,
                                           handler: didTapNoButton)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
     
}
