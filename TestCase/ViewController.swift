import UIKit
import Alamofire 

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBAction func switchChanged(_ sender: Any) {
        refresh("Change")
    }
    
    var refreshControl = UIRefreshControl()
    var result: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: Any) {
        Alamofire.request("http://jsonplaceholder.typicode.com/posts").responseJSON { response in
            self.refreshControl.endRefreshing()
            
            if let error = response.error {
                print(error.localizedDescription)
                return
            }
            
            
            if let responseJson = response.value as? [Any] {
                
                self.result = self.switchBtn.isOn ? responseJson.filter({
                    (($0 as? [String:Any])?["id"] as? Int ?? 1) % 2 == 0
                }) : responseJson
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let jsonAny: Any? = self.result[indexPath.row]
        let jsonDict: ([String: Any])? = jsonAny as? [String:Any]
        
        
        
        cell.titleLbl?.text = (jsonDict?["title"] as! String)
        cell.bodyTextView?.text = (jsonDict?["body"] as! String)
        cell.idLbl!.text = "ID: \(jsonDict?["id"] ?? "no")"
        cell.userIdLbl!.text = "\(jsonDict?["userId"] ?? "no")"
        cell.titleLbl.sizeToFit()
        
        return cell
    }
    



}

