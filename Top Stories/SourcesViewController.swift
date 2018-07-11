//
//  ViewController.swift //SourcesViewController
//  Top Stories
//
//  Created by Benecia Shi on 7/10/18.
//  Copyright © 2018 Benecia Shi. All rights reserved.
//

//remember to push the changes to Github, "...to push commits made on your local branch to a remote repository. The git push command takes two arguments: A remote name, for example, origin. A branch name, for example, master..."-pushing to a remote, GitHub Help

import UIKit

class SourcesViewController: UITableViewController {
    
    @IBAction func onDoneButtonTapped(_ sender: Any) {
        exit(0) //0? (idk) //closes app when the button is tapped
    }
    
    var sources = [[String: String]]()
    let apiKey = "5d892509a49046a087917c466fa80d09"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News Sources"
        let query = "https://newsapi.org/v1/sources?language=en&country=us&apiKey=\(apiKey)"
        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    if json["status"] == "ok" {
                        self.parse(json: json) //self cuz it's inside a closure
                        return //exiting the method
                    }
                }
            }
        self.loadError() //otherwise...?
        // Do any additional setup after loading the view, typically from a nib.
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let source = sources[indexPath.row]
        cell.textLabel?.text = source["name"]
        cell.detailTextLabel?.text = source["description"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count //adds own specifications
    }
    
    
    func parse(json: JSON) {
        for result in json["sources"].arrayValue {
            let id = result["id"].stringValue
            let name = result["name"].stringValue
            let description = result["description"].stringValue
            
            let source = ["id": id, "name": name, "description": description]
            sources.append(source)
        }
        DispatchQueue.main.async {
            [unowned self] in //unowned?
            self.tableView.reloadData()
        }
    }
    
    func loadError() {
        DispatchQueue.main.async {
            [unowned self] in
            let alert = UIAlertController(title: "LoadingError", message: "There was a problem loading the news feed", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! ArticlesViewController //[segue to ArticlesViewController code]
        let index = tableView.indexPathForSelectedRow?.row
        dvc.source = sources [index!]
        dvc.apiKey = apiKey
    }


}

