//
//  ImageButtonCell.swift
//  TestAPI
//
//  Created by 土橋正晴 on 2020/11/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import UIKit
import Photos

protocol ImageButtonCellDelegate: class {
    func didTapImageCell()
}


final class ImageButtonCell: UITableViewCell {
    
    weak var delegate: ImageButtonCellDelegate!
    
    @IBOutlet weak var imageV: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            delegate.didTapImageCell()
        }
    }
    
    
    
    
}




