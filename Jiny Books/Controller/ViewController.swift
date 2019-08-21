//
//  ViewController.swift
//  Jiny Books
//
//  Created by 3Embed on 19/08/19.
//  Copyright © 2019 Demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var booksTable: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerTopConstraint: NSLayoutConstraint!
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    var books = [Book]()
    var pickerList = ["Author name", "Author Country", "Genre"]
    var filter = ""
    var selectesIndex = 0
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        booksTable.rowHeight = UITableView.automaticDimension
        booksTable.estimatedRowHeight = 40.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if books.count == 0 {
            booksTable.isHidden = true
        } else {
            booksTable.isHidden = false
        }
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.gray
        view.addSubview(activityIndicator)
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        fetchBooks()
    }
    
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        self.pickerTopConstraint.constant = 0
        UIView.animate(withDuration: 0.03) {
            self.view.layoutIfNeeded()
        }
      
        
    }
    
    
    @IBAction func refreshBtnTapped(_ sender: Any) {

        filter = ""
        fetchBooks()
    }
    
   
    //call API
    
    func fetchBooks() {
        activityIndicator.startAnimating()
        guard let url = URL(string: "http://android.jiny.mockable.io/getAll") else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options:[] ) as? [String:Any]
                 
                    
                    if let booksArray = json?["list"] as? [[String:Any]] {
                        booksArray.map {
                            self.books.append(Book.init(json: $0))
                        }
                       
                    }
                    
                    DispatchQueue.main.async {
                        self.createBtn.isHidden = true
                        self.booksTable.isHidden = false
                        self.booksTable.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                    
                }catch {
                    print(error)
                    
                }
                
                
                
            }
            
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextVC" {
            let vc = segue.destination as? NextViewController

            vc?.books = self.books
            if filter == "" {
                vc?.filtertext = ""
            }else if filter == "Author name"{
                 vc?.filtertext = books[selectesIndex].author
            }  else if filter == "Author Country" {
                 vc?.filtertext = books[selectesIndex].country
            }else if filter == "Genre" {
                 vc?.filtertext = books[selectesIndex].genre
            }
        }
     }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return books.count > 0  ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookCell
        
        if  filter == "" {
            cell.titleLabel.text = books[indexPath.row].title
        } else if filter == "Author name"{
             cell.titleLabel.text = books[indexPath.row].author
        } else if filter == "Author Country"{
            cell.titleLabel.text = books[indexPath.row].country
        } else if filter == "Genre" {
            cell.titleLabel.text = books[indexPath.row].genre
        }
        
        if books[indexPath.row].isBookmarked {
            cell.bookmarkImage.image = #imageLiteral(resourceName: "bookmark")
        } else {
            cell.bookmarkImage.image = #imageLiteral(resourceName: "unbookmark")
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectesIndex = indexPath.row
        
        performSegue(withIdentifier: "nextVC", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            books.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leftAction = UIContextualAction(style: .normal, title:  "Bookmark", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.books[indexPath.row].isBookmarked = true
            self.booksTable.reloadData()
            
            success(true)
        })
        
        leftAction.image = UIImage(named: "")
        leftAction.backgroundColor = UIColor.gray
        
        return UISwipeActionsConfiguration(actions: [leftAction])
    }
    
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
        filter = pickerList[row]
        self.pickerTopConstraint.constant = -250
        UIView.animate(withDuration: 0.03) {
            self.view.layoutIfNeeded()
        }
        
       
       
        booksTable.reloadData()
    }
}
