//
//  NextViewController.swift
//  BooksDemo
//
//  Created by 3Embed on 06/08/19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

class NextViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var booksTable: UITableView!
    
    var books = [Book]()
    var filtertext = ""
    var selectedIndex = 0
    var filteredBooks = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        booksTable.rowHeight = UITableView.automaticDimension
        booksTable.estimatedRowHeight = 100.0
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredBooks  = books.filter {$0.author == filtertext ||
            $0.genre == filtertext ||
            $0.country == filtertext
            
        }
        
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            let vc = segue.destination as? DetailViewController
          
            if filtertext == "" {
                vc?.book = books[selectedIndex]
            } else {
                vc?.book = filteredBooks[selectedIndex]
            }
            
        }
    }
 

}

extension NextViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtertext == "" ?  books.count : filteredBooks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksDetailCell") as! BooksDetailCell
        var book: Book?
        if filtertext == "" {
               book = books[indexPath.row]
        } else {
               book = filteredBooks[indexPath.row]
        }
        
      
        cell.author.text = book?.author
        cell.bookTitle.text = book?.title
        cell.genre.text = book?.genre
       
        DispatchQueue.global().async {
            let url = URL(string: book?.image ?? "")
                    let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
            if let imageData = data {
                    cell.bookImage.image = UIImage(data: imageData)
                }
            }
        }
        

        return cell
}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "detailVC", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    
        books = books.filter { $0.genre.contains(searchBar.text ?? "")  || ($0.title.contains(searchText)) ||
                $0.author.contains(searchText)
        }
        
        booksTable.reloadData()
        
        
    }


}
