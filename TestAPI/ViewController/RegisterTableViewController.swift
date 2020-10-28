//
//  InputViewController.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/05.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit


// MARK: - RegisterViewController

protocol RegisterTableViewControllerProtocol {
    /// ユーザを登録する
    func postUser()
    
    /// ユーザを更新する
    func putUser()
}



// MARK: - RegisterViewController

class RegisterTableViewController: UITableViewController {
    
    // MARK: Properties
    private var userModel: UsersModel?
    
    
    private(set) var mode: Mode = .add
    
    /// プレゼンター
    private var presenter: RegisterViewControllerPresenter?
    
    
    private var name: String?
    
    private var text: String?
    
    private var imageStr: String?
    
    
    
    // MARK: Init
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        presenter = RegisterViewControllerPresenter()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
    /// ModeとuserModelを格納するInit
    /// - Parameters:
    ///   - mode: Mode Enum
    ///   - userModel: 開くuserModelを格納
    convenience init(style: UITableView.Style = .grouped, mode: Mode, userModel: UsersModel?) {
        self.init(style: style)
        self.mode = mode
        self.userModel = userModel
        
        
        if mode != .detail {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarAction))
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    // MARK: NavigationItem
    
    override func rightBarAction() {
        if mode == .add {
            postUser()
            
        } else if mode == .edit {
            putUser()
            
        }
        
    }
    

    
    // MARK: Mode Enum
    
    enum Mode {
        case add, edit, detail
    }
    
}





extension RegisterTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let leading: CGFloat = 10
        
        switch indexPath.section {
        case 0:
            let nameTextField = UITextField()
            nameTextField.delegate = self
            nameTextField.placeholder = "名前を入力してください"
            nameTextField.accessibilityIdentifier = "nameTextField"
            if mode != .add {
                nameTextField.text = userModel?.name
                if mode == .detail {
                    nameTextField.isUserInteractionEnabled = false
                }
            }
            cell.contentView.addSubview(nameTextField)
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            nameTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            nameTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            nameTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: leading).isActive = true
            nameTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -leading).isActive = true
            
        case 1:
            let textView = UITextView()
            textView.delegate = self
            textView.accessibilityIdentifier = "inputTextView"
            if mode != .add {
                textView.text = userModel?.text
                if mode == .detail {
                    textView.isUserInteractionEnabled = false
                }
            }
            
            cell.contentView.addSubview(textView)
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            textView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            textView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: leading).isActive = true
            textView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -leading).isActive = true

        case 2:
            break
        default:
            break
        }
        
        return cell
    }
    
}





// MARK: - RegisterViewControllerPresenterProtocol

extension RegisterTableViewController: RegisterTableViewControllerProtocol {
    
    func postUser() {
        presenter?.postRequest(name: name, text: text, success: {
            
            AlertManager().alertAction(viewController: self,
                                       title:"", message: "ユーザを保存しました") { _ in
                                        self.dismiss(animated: true) {
                                            NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                                        }
            }
            
        }) { title, message in
            AlertManager().alertAction(viewController: self, title: title, message: message, didTapButton: { _ in
                return
            })
        }
    }
    
    
    func putUser() {
        presenter?.putRequest(id: self.userModel?.id, name: name, text: text, success: {
            
            AlertManager().alertAction(viewController: self,
                                       title: "", message: "ユーザを更新しました") { _ in
                                        self.dismiss(animated: true) {
                                            NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                                        }
            }
            
            
        }) { title ,message in
            AlertManager().alertAction(viewController: self, title: title, message: message, didTapButton: { _ in
                return
            })
        }
    }
    
    
}




// MARK: - TextField Delegate, TextView Delegate

extension RegisterTableViewController: UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: TextField Delegate
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        name = textField.text
        
        if name == nil {
            isModalInPresentation = false
        } else {
            isModalInPresentation = true
        }
    }
    
    
    
    
    // MARK: TextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
        
        if name == nil {
            isModalInPresentation = false
        } else {
            isModalInPresentation = true
        }
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

