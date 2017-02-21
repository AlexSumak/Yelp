//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController{
    
    //infin scroll vars
    var isMoreDataLoading = false
    var searcher: String = ""
    
    //searchbar var
    @IBOutlet weak var SearchBar: UISearchBar!
    
    lazy var businesses = [Business]() //initially, this is empty array of business
    //var businesses: [Business]!  this is an optional
    
    //table view var
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initilazers for UITableViewDataSource, UITableViewDelegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // for constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        // search bar things
        self.SearchBar.delegate = self
        self.SearchBar.barTintColor = UIColor.clear
        self.SearchBar.backgroundImage = UIImage()
        self.SearchBar.placeholder = "Search for bussiness"
        self.navigationItem.titleView = self.SearchBar
        self.SearchBar.tintColor = UIColor.black
        
        //before this point, because the lazy, the business has not been initialized
        //and it will be initilaized only when somewhere in your code start using it
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        self.isMoreDataLoading = true
        Business.searchWithTerm(term: "Thai", offset: self.businesses.count, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses{
                //if there is a chance that this variable will be nil, then you want to use if let statement
                //this won't crash your app when it's nil
                self.businesses.append(contentsOf: businesses) //self.businesses will contain 20 buesiness, for the first fetch
                self.isMoreDataLoading = false
                self.tableView.reloadData()
            }
        })
    }
    
}



extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate{
    
    // requared function for UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    
    // requared function for UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"BusinessCell" , for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    
}


// extension for search bar. just copy/paste it if you need it
extension BusinessesViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = nil
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        let searchText = searchBar.text!
        Business.searchWithTerm(term: searchText, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses{
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
        )
        view.endEditing(true)
    }
}




//infifnite scroll extension
extension BusinessesViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                self.loadData()
            }
        }
    }
}
