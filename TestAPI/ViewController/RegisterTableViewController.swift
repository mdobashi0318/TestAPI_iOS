//
//  InputViewController.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/05.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit
import Photos

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
    
    private var imageButtonCell: ImageButtonCell!
    
    // MARK: Init
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        presenter = RegisterViewControllerPresenter()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageButtonCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    
    
    
    /// ModeとuserModelを格納するInit
    /// - Parameters:
    ///   - mode: Mode Enum
    ///   - userModel: 開くuserModelを格納
    convenience init(style: UITableView.Style = .grouped, mode: Mode, userModel: UsersModel?) {
        self.init(style: style)
        self.mode = mode
        self.userModel = userModel
        if let model = userModel {
            name = model.name
            text = model.text
            imageStr = model.image
        }
        
        
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




// MARK: - UITableViewDataSource, UITableViewDelegate

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
                nameTextField.text = name
                if mode == .detail {
                    nameTextField.isUserInteractionEnabled = false
                    cell.selectionStyle = .none
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
                textView.text = text
                if mode == .detail {
                    textView.isUserInteractionEnabled = false
                    cell.selectionStyle = .none
                }
            }
            
            cell.contentView.addSubview(textView)
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            textView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            textView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: leading).isActive = true
            textView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -leading).isActive = true

        case 2:
            imageButtonCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ImageButtonCell
            imageButtonCell.delegate = self
            
            if let imageStr = imageStr,
               let data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters){
                imageButtonCell.imageV.image = UIImage(data: data)
            }
            
            if mode == .detail {
                imageButtonCell.isSelected = false
                imageButtonCell.selectionStyle = .none
            }
            
            return imageButtonCell
            
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 70
        }
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if mode == .detail {
            return nil
        }
        return indexPath
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}





// MARK: - RegisterViewControllerPresenterProtocol

extension RegisterTableViewController: RegisterTableViewControllerProtocol {
    
    func postUser() {
        presenter?.postRequest(name: name, text: text, image: imageStr, success: {
            
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
        presenter?.putRequest(id: self.userModel?.id, name: name, text: text, image: imageStr, success: {
            
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




// MARK: - UIImagePickerControllerDelegate

extension RegisterTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[.originalImage] as! UIImage
        let imageData: Data = image.pngData()! as Data
        imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
        
        if let imageStr = imageStr,
           let data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters){
            imageButtonCell.imageV.image = UIImage(data: data)
        } else {
            imageStr = nil
            imageButtonCell.imageV.image = nil
        }
    }
    
}



// MARK: - ImageButtonCellDelegate

extension RegisterTableViewController: ImageButtonCellDelegate {
    
    func didTapImageButton() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        default:
            PHPhotoLibrary.requestAuthorization { _ in
            }
            
        }

    }
    
    
    
    
    
}
