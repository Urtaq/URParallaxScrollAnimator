//
//  URExampleTableViewCell.swift
//  URExampleScrollingAnimator
//
//  Created by DongSoo Lee on 2017. 3. 27..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class URExampleTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lbContent: UILabel!

    func configView(image: UIImage, text: String) {
        self.imgView.image = image

        self.lbContent.text = text
    }
}
