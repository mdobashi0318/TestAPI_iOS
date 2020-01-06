//
//  InputViewController.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/05.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit


// MARK: - RegisterViewController

class RegisterViewController: UIViewController {
    
    // MARK: Properties
    
    lazy var registerView: RegisterView = {
        let view = RegisterView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height)
        )
        view.backgroundColor = .white
        
        switch mode {
        case .edit:
            view.nameTextField.text = userModel?["name"] as? String
            
        case .detail:
            view.nameTextField.text = userModel?["name"] as? String
            view.nameTextField.isUserInteractionEnabled = false
            
        default:
            break
        }
        return view
    }()
    
    
    private var userModel: [String:Any]?
    
    
    private var mode: Mode = .add
    
    
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    /// ModeとuserModelを格納するInit
    /// - Parameters:
    ///   - mode: Mode Enum
    ///   - userModel: 開くuserModelを格納
    convenience init(mode: Mode, userModel:[String:Any]?) {
        self.init()
        self.mode = mode
        self.userModel = userModel
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode != .detail {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarAction))
        }
        view.addSubview(registerView)
    }
    
    
    
    
    // MARK: NavigationItem
    
    override func rightBarAction() {
        
        guard !registerView.nameTextField.text!.isEmpty else {
            AlertManager().alertAction(viewController: self,
                                       title: "", message: "名前が入力されていません") { _ in return
            }
            return
        }
        
        let name: String = registerView.nameTextField.text!
        
        if mode == .add {
            postRequest(name: name)
        } else if mode == .edit {
            putRequest(name: name)
        }
    }
    
    
    
    
    // MARK: Request
    
    /// ユーザー名を作成する
    func postRequest(name: String) {
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params:[String:Any] = [
            "user":["name":name]
        ]
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                print("data")
                print(data!)
                print("respnse")
                print(response!)
                
            })
            task.resume()
            
            AlertManager().alertAction(viewController: self,
                                       title: "", message: "名前を保存しました") { _ in
                                        self.dismiss(animated: true) {
                                            NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                                        }
            }
            
        } catch {
            AlertManager().alertAction(viewController: self,
                                       title: "", message: "エラーが発生しました") { _ in return
                                        
            }
            return
        }
        
    }
    
    
    /// ユーザ名を更新する
    func putRequest(name: String) {
        
        guard let id = userModel!["id"] else {
            print("idの取得に失敗")
            return
        }
        
        let acccesURL = URL(string: String("\(url!)/\(id)"))
           var request = URLRequest(url: acccesURL!)
           request.httpMethod = "PUT"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           
           let params:[String:Any] = [
               "user":["name":name]
           ]
           
           
           do {
               request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
               let task:URLSessionDataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                   print("data")
                   print(data!)
                   print("respnse")
                   print(response!)
                   
               })
               task.resume()
            
            AlertManager().alertAction(viewController: self,
                                             title: "", message: "名前を更新しました") { _ in
                                              self.dismiss(animated: true) {
                                                  NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                                              }
                  }
           } catch {
               AlertManager().alertAction(viewController: self,
                                          title: "", message: "エラーが発生しました") { _ in return
                                           
               }
               return
           }
       }

    
    
    
    // MARK: Mode Enum
    
    enum Mode {
        case add, edit, detail
    }
    
}















// MARK: - RegisterView


class RegisterView: UIView {
    
    // MARK: Properties
    
    let _bounds:CGRect = UIScreen.main.bounds
    
    /// 名前入力TextField
    lazy var nameTextField: UITextField = {
        let textfield: UITextField = UITextField()
        textfield.frame = CGRect(x: 20, y: _bounds.origin.y + 100, width: _bounds.width * 0.8, height: 50)
        textfield.placeholder = "名前を入力してください"
        
        return textfield
    }()
    
    
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameTextField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

