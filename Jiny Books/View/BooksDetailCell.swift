//
//  BooksDetailCell.swift
//  BooksDemo
//
//  Created by 3Embed on 06/08/19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

class BooksDetailCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
