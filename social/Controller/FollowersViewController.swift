//
//  FollowersViewController.swift
//  social
//
//  Created by Gabriel Lucas Santos on 23/05/21.
//

import UIKit

class FollowersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let kBaseURL = "https://jsonplaceholder.typicode.com"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFollowers()
    }
    
    private var followers = [Follower]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    fileprivate func loadFollowers() {
        if let url = URL(string: "\(kBaseURL)/users/") {
            let session = URLSession.shared

            let request = URLRequest(url: url)
            
            let task = session.dataTask(with: request) { (data, resp, error) in
                if let response = resp as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 {
                    if let followers = try? JSONDecoder().decode([Follower].self, from: data!) {
                        DispatchQueue.main.async {
                            self.followers = followers
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "onFollowerSegue" {
            print("Sender: \(sender ?? "não veio!")")
            if let followerCell = sender as? FollowersTableViewCell, let follower = followerCell.follower {
                let albumViewController = segue.destination as! AlbumViewController
                albumViewController.followerId = follower.id

            }
        }
    }
}

extension FollowersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let follower = followers[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell", for: indexPath) as! FollowersTableViewCell
        cell.follower = follower
        
        return cell
    }
    
}

extension FollowersViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
}

