//
//  ImageButtonCell.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/11/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit

protocol ImageButtonCellDelegate: class {
    func didTapImageButton()
}


final class ImageButtonCell: UITableViewCell {
    
    weak var delegate: ImageButtonCellDelegate!
    
    @IBOutlet weak var imageViewButton: UIButton!
    
    @IBAction func didTapImageButton(_ sender: UIButton) {
        delegate.didTapImageButton()
    }
    
}




