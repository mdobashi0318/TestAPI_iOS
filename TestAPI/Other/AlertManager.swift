//
//  AlertManager.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/04.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit

class AlertManager {
    
    
    
    /// 閉じるボタンが付いたアラート
    func alertAction(viewController:UIViewController, title: String, message: String, handler: @escaping (UIAlertAction) -> ()){
        let controller:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .default,
                                           handler: handler)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    /// 「削除」、「閉じる」が付いたアラート
    func alertAction(viewController:UIViewController, title: String?, message: String, handler1: @escaping (UIAlertAction)->(),handler2: @escaping (UIAlertAction) -> ()){
        let controller:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "削除",
                                           style: .destructive,
                                           handler: handler1)
        )
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .default,
                                           handler: handler2)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
}
