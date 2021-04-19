//
//  See LICENSE file for this project's licensing information.
//

import UIKit
import Combine

/// A view controller for our list view
class ListController: UITableViewController {
    
    /// The table's data source
    var listItems = [ListItem]()
    
    /// The list's data source
    var listViewModel = ListViewModel()
    
    /// Indicator view for when table is loading
    var indicator = UIActivityIndicatorView()
    
    /// Combine helper
    private var cancellables = Set<AnyCancellable>()
    
    /// Preliminary setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTable()
        setupActivityIndicator()
        setupBindings()
    }
    
    /// Setups of the navigation properties for this controller
    private func setupNavigation() {
        
        // Setup title
        navigationItem.title = "List Controller"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup bar button
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(onTapRightBarButton)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    /// Sets up the table properties
    private func setupTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
    }
    
    /// Sets up the activity indicator
    private func setupActivityIndicator() {
        self.indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.indicator.style = UIActivityIndicatorView.Style.medium
        self.indicator.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 20)
        self.indicator.startAnimating()
        self.indicator.backgroundColor = .clear
        self.tableView.addSubview(indicator)
    }
    
    /// Sets up the view's bindings to the view model
    private func setupBindings() {
        listViewModel.$listItems
        .receive(on: DispatchQueue.main)
        .sink { [weak self] listItems in
            
            self?.listItems = listItems
            if self?.listItems.count ?? 0 > 0 {
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.indicator.stopAnimating()
                self?.indicator.hidesWhenStopped = true
                self?.tableView.separatorStyle = .singleLine
            }
            
            UIView.transition(
                with: (self?.tableView)!,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { self?.tableView.reloadData() },
                completion: nil
            )
            
        }
        .store(in: &cancellables)
    }
    
    /// Action called when bar button is tapped
    @objc private func onTapRightBarButton() {
        if listViewModel.listItems.count > 0 {
            self.listViewModel.addListItem("List Item \(listItems.count + 1)")
        }
    }
    
    /// The number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    /// Creates the table's cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listItems[indexPath.row].title
        return cell
    }
    
}
