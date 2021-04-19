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
    
    /// Combine helper
    private var cancellables = Set<AnyCancellable>()
    
    /// Preliminary setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTable()
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
        
    }
    
    /// Action called when bar button is tapped
    @objc private func onTapRightBarButton() {
        if listViewModel.listItems.count > 0 {
            self.listViewModel.addListItem("List Item \(listItems.count + 1)")
        }
    }
    
    /// Sets up the table properties
    private func setupTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    /// Sets up the view's bindings to the view model
    private func setupBindings() {
        listViewModel.$listItems
        .receive(on: DispatchQueue.main)
        .sink { [weak self] listItems in
            self?.listItems = listItems
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
    
}
