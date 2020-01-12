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
            view.nameTextField.text = userModel?.name
            
            view.textView.text = userModel?.text
        case .detail:
            view.nameTextField.text = userModel?.name
            view.nameTextField.isUserInteractionEnabled = false
            
            
            view.textView.text = userModel?.text
            view.textView.isUserInteractionEnabled = false
        default:
            break
        }
        return view
    }()
    
    
    private var userModel: UsersModel?
    
    
    private var mode: Mode = .add
    
    
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    /// ModeとuserModelを格納するInit
    /// - Parameters:
    ///   - mode: Mode Enum
    ///   - userModel: 開くuserModelを格納
    convenience init(mode: Mode, userModel:UsersModel?) {
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
        
        
        guard !registerView.nameTextField.text!.isEmpty else {
            AlertManager().alertAction(viewController: self,
                                       title: "", message: "テキストが入力されていません") { _ in return
            }
            return
        }
        
        let name: String = registerView.nameTextField.text!
        let text: String = registerView.textView.text!
        
        if mode == .add {
            UsersModel.postRequest(viewController: self, name: name, text: text)
        } else if mode == .edit {
            UsersModel.putRequest(viewController: self, id: userModel?.id, name: name, text: text)
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
        textfield.accessibilityIdentifier = "nameTextField"
        textfield.layer.borderWidth = 0.5
        
        return textfield
    }()
    
    
    
    /// テキストビュー
    lazy var textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.frame = CGRect(x: 20, y: nameTextField.frame.origin.y + nameTextField.frame.height + 50, width: _bounds.width * 0.8, height: 100)
        textView.layer.borderWidth = 0.5
        textView.accessibilityIdentifier = "inputTextView"
        
        return textView
    }()
    
    
    
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameTextField)
        addSubview(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

