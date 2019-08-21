//
//  DetailViewController.swift
//  Jiny Books
//
//  Created by 3Embed on 19/08/19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navitem: UINavigationItem!
    
    var book : Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    

    func setupUI() {
        authorLabel.text = book?.author
        genreLabel.text = book?.genre
        countryLabel.text = book?.country
        //titleLabel.text = book?.title
        navitem.title = book?.title
        DispatchQueue.global().async {
            let url = URL(string: (self.book?.image)!)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let imageData = data {
                    self.bookImage.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    
}
