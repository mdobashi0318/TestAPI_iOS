//
//  InputViewController.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/01/05.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit
import Photos
import PKHUD

// MARK: - RegisterViewController

protocol RegisterTableViewControllerProtocol {
    /// ユーザを登録する
    func postUser()
    
    /// ユーザを更新する
    func putUser()
}


// MARK: - RegisterCellType

fileprivate enum RegisterCellType: Int, CaseIterable {
    case name = 0
    case text = 1
    case image = 2
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
    
    private var imageWindow: UIWindow?
    
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
    
    
    // MARK: Func
    
    private func makeImageWindow() {
        guard let imageStr = imageStr,
           let data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters) else {
            print("表示できる画像がありません")
            return
        }
        
        imageWindow = UIWindow()
        
        guard let selfWindow = self.view.window,
              let imageWindow = imageWindow else {
            return
        }
        let view = UIImageView(image: UIImage(data: data))
        let closeButton = UIButton()
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
        imageWindow.addSubview(closeButton)
        
        imageWindow.backgroundColor = .black
        imageWindow.alpha = 0.8
        imageWindow.makeKeyAndVisible()
        imageWindow.addSubview(view)
        selfWindow.addSubview(imageWindow)
        
        imageWindow.translatesAutoresizingMaskIntoConstraints = false
        imageWindow.topAnchor.constraint(equalTo: selfWindow.topAnchor).isActive = true
        imageWindow.leadingAnchor.constraint(equalTo: selfWindow.leadingAnchor).isActive = true
        imageWindow.trailingAnchor.constraint(equalTo: selfWindow.trailingAnchor).isActive = true
        imageWindow.bottomAnchor.constraint(equalTo: selfWindow.bottomAnchor).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: imageWindow.topAnchor, constant: 40).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: imageWindow.trailingAnchor, constant: -15).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerYAnchor.constraint(equalTo: imageWindow.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: imageWindow.centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.2).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.2).isActive = true
    }
    
    
    @objc private func didTapCloseButton(_ sender: UIButton) {
        imageWindow?.isHidden = true
        imageWindow = nil
    }
}




// MARK: - UITableViewDataSource, UITableViewDelegate

extension RegisterTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return RegisterCellType.allCases.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let leading: CGFloat = 10
        let cellType = RegisterCellType(rawValue: indexPath.section)
        
        switch cellType {
        case .name:
            let nameTextField = UITextField()
            nameTextField.delegate = self
            nameTextField.placeholder = "名前を入力してください"
            nameTextField.accessibilityIdentifier = "nameTextField"
            nameTextField.backgroundColor = cell.backgroundColor
            
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
            
        case .text:
            let textView = UITextView()
            textView.delegate = self
            textView.accessibilityIdentifier = "inputTextView"
            textView.backgroundColor = cell.backgroundColor
            
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

        case .image:
            imageButtonCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ImageButtonCell
            imageButtonCell.delegate = self
            
            if let imageStr = imageStr,
               let data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters){
                imageButtonCell.imageViewButton.setBackgroundImage(UIImage(data: data), for: .normal)
            } else {
                imageButtonCell.imageViewButton.setBackgroundImage(nil, for: .normal)
            }
            
            if mode == .detail {
                imageButtonCell.isSelected = false
                imageButtonCell.selectionStyle = .none
            }
            
            return imageButtonCell
        case .none:
            break
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = RegisterCellType(rawValue: indexPath.section)
        
        switch cellType {
        case .image:
            return 70
        default:
            return 50
        }
        
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
        HUD.show(.progress)
        presenter?.postRequest(name: name, text: text, image: imageStr, success: {
            HUD.hide()
            AlertManager().alertAction(viewController: self,
                                       title:"", message: "ユーザを保存しました") { _ in
                                        self.dismiss(animated: true) {
                                            NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                                        }
            }
            
        }) { title, message in
            HUD.hide()
            AlertManager().alertAction(viewController: self, title: title, message: message, didTapButton: { _ in
                return
            })
        }
    }
    
    
    func putUser() {
        HUD.show(.progress)
        presenter?.putRequest(id: self.userModel?.id, name: name, text: text, image: imageStr, success: {
            HUD.hide()
            AlertManager().alertAction(viewController: self,
                                       title: "", message: "ユーザを更新しました") { _ in
                                        self.dismiss(animated: true) {
                                            NotificationCenter.default.post(name: Notification.Name(ViewUpdate), object: nil)
                                        }
            }
            
            
        }) { title ,message in
            HUD.hide()
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
        isModalInPresentation = true
        
        if let imageStr = imageStr,
           let data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters){
            imageButtonCell.imageViewButton.setBackgroundImage(UIImage(data: data), for: .normal)
        } else {
            imageStr = nil
            imageButtonCell.imageViewButton.setBackgroundImage(nil, for: .normal)
        }
    }
    
}



// MARK: - ImageButtonCellDelegate

extension RegisterTableViewController: ImageButtonCellDelegate {
    

    
    func didTapImageButton() {
        
        if mode == .detail {
            makeImageWindow()
        } else {
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

}
