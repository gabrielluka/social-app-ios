//
//  PostViewController.swift
//  social
//
//  Created by Gabriel Lucas Santos on 23/05/21.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let kBaseURL = "https://jsonplaceholder.typicode.com/posts"
    
    
    private var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPost()
    }

    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        
        PostTableViewCell.register(inside: tableView)
    }
    
    fileprivate func loadPost() {
        guard let url = URL(string: kBaseURL) else {
            return
        }
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
               response.statusCode >= 200,
               response.statusCode < 300 {
                guard let data = data, let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.posts = posts
                }
            }
        }.resume()
    }
}

extension PostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.kReuseIdentifier, for: indexPath) as! PostTableViewCell
        cell.setup(with: "Gabriel Ipsum", post: posts[indexPath.row])
        return cell
    }
    
}

extension PostViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
}
