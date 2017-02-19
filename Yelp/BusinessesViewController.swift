//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    
    
    //infin scroll vars
    var isMoreDataLoading = false
    var searcher: String = ""
    
    
    //searchbar var
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var businesses: [Business]!
    //table view var
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //initilazers for UITableViewDataSource, UITableViewDelegate
        tableView.delegate = self
        tableView.dataSource = self
     
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120


        // search bar things
        self.SearchBar.delegate = self
        self.SearchBar.barTintColor = UIColor.clear
        self.SearchBar.backgroundImage = UIImage()
        self.SearchBar.placeholder = "Search for bussiness"
        self.navigationItem.titleView = self.SearchBar
        self.SearchBar.tintColor = UIColor.black
        
        
       
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
 
      
    }
    func loadMoreEntries(){
        Business.searchWithTerm(term: self.searcher, offset: self.businesses?.count, limit: nil) { (businesses, error) in
            if let newBusinesses = businesses, newBusinesses.count > 0{
                self.isLoadingData = false
                self.businesses?.append(contentsOf: newBusinesses)
                DispatchQueue.main.async {
                    self.containerView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }else{
                self.loadingFooterView.isHidden = true
            }
        }
    }
    
    func loadMoreData(){
        Business.searchWithTerm(term: self.searcher, offset: self.businesses?.count, limit: nil) { (businesses, error) in
            if let newBusinesses = businesses, newBusinesses.count > 0{
                self.isLoadingData = false
                self.businesses?.append(contentsOf: newBusinesses)
                DispatchQueue.main.async {
                    self.containerView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }else{
                self.loadingFooterView.isHidden = true
            }
        }
    }

    
    // requared function for UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return self.businesses!.count
        } else {
            return 0
        }
    }
    
    
    // requared function for UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"BusinessCell" , for: indexPath) as! BusinessCell
            cell.business = businesses![indexPath.row]
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!self.isMoreDataLoading){
            if(scrollView.contentOffset.y > scrollView.contentSize.height - self.view.frame.size.height){
                self.isMoreDataLoading = true
                self.loadMoreData()
            }
        }
    }
    

 
  
}






// class for search bar. just copy/paste it if you need it
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
            
            self.businesses = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }
        )
        view.endEditing(true)
    }
    
}




