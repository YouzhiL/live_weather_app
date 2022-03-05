//
//  LiveWeatherTableViewController.swift
//  live_weatherAPP
//
//  Created by Youzhi Liang on 2/18/22.
//

import UIKit
class weatherInfoCell: UITableViewCell {
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var weather: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
}
class LiveWeatherTableViewController: UITableViewController {
    
    
    // MARK: - TodoItem
    struct TodoItem: Codable {
        let location: Location
        let current: Current
    }

    // MARK: - Current
    struct Current: Codable {
        let lastUpdated: String
        let tempC, tempF: Double
        let condition: Condition
        let windMph: Double
        let humidity: Int
        let feelslikeC, feelslikeF: Double

        enum CodingKeys: String, CodingKey {
            case lastUpdated = "last_updated"
            case tempC = "temp_c"
            case tempF = "temp_f"
            case condition
            case windMph = "wind_mph"
            case humidity
            case feelslikeC = "feelslike_c"
            case feelslikeF = "feelslike_f"
        }
    }

    // MARK: - Condition
    struct Condition: Codable {
        let text, icon: String
    }

    // MARK: - Location
    struct Location: Codable {
        let name, region, localtime: String
    }
    
    var allTodos:[TodoItem] = []
    
    override func viewDidLoad() {
        self.getAllData()
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        self.allTodos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! weatherInfoCell

        // Configure the cell...
        cell.city.text = allTodos[indexPath.row].location.name
        cell.weather.text = String(allTodos[indexPath.row].current.condition.text)
        cell.temperature.text = String(allTodos[indexPath.row].current.tempF) + "°F"
//        let imgURL = allTodos[indexPath.row].current.condition.icon
//        let index = imgURL.index(imgURL.startIndex, offsetBy: 2)
//        let imgurl = imgURL.substring(from: index)
        cell.weatherImage.image = self.getImg(weather: String(allTodos[indexPath.row].current.condition.text))
        
        return cell
    }
    
    func getAllData() {
        let headers = [
            "x-rapidapi-host": "weatherapi-com.p.rapidapi.com",
            "x-rapidapi-key": "84e6ccd72fmsh2be1deca4bfc5ccp145ce2jsn2e418b2b06f5"
        ]
        let defaultURLS = ["https://weatherapi-com.p.rapidapi.com/forecast.json?q=durham&days=3","https://weatherapi-com.p.rapidapi.com/forecast.json?q=new%20york&days=3","https://weatherapi-com.p.rapidapi.com/forecast.json?q=chicago&days=3","https://weatherapi-com.p.rapidapi.com/forecast.json?q=Shanghai&days=3","https://weatherapi-com.p.rapidapi.com/forecast.json?q=London&days=3","https://weatherapi-com.p.rapidapi.com/forecast.json?q=Paris&days=3","https://weatherapi-com.p.rapidapi.com/forecast.json?q=Moscow&days=3"]
        for url in defaultURLS{
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
    //            if (error != nil) {
    //                print(error)
    //            } else {
    //                let httpResponse = response as? HTTPURLResponse
    //                print(httpResponse)
    //            }
                guard error == nil else {
                    print ("Error: \(error!)") // local console message for debug

                     DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error - ", message: "\(error!)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                     
                    return
                }
                // ensure there is data returned from this HTTP response
                guard let jsonData = data else {
                    print("No data")
                    return
                }
                do {
                    let todoData = try JSONDecoder().decode(TodoItem.self, from: jsonData)
                    self.allTodos.append(todoData)
                    print("Done!")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                       let alert = UIAlertController(title: "JSON Decode Error - ", message: "\(error)", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       self.present(alert, animated: true)
                   }
                }
            })
            dataTask.resume()
        }
    }
    func getImg(weather:String) -> UIImage{
        if weather.range(of: "rain", options: .caseInsensitive) != nil {
            return UIImage(named: "rainy")!
        } else if weather.range(of: "shower", options: .caseInsensitive) != nil {
            return UIImage(named: "rainy")!
            
        } else if weather.range(of: "sun", options: .caseInsensitive) != nil {
            return UIImage(named: "sunny")!

        } else if weather.range(of: "cloud", options: .caseInsensitive) != nil{
            return UIImage(named: "cloudy")!
        } else if weather.range(of: "overcast", options: .caseInsensitive) != nil {
            return UIImage(named: "other")!
        } else if weather.range(of: "snow", options: .caseInsensitive) != nil {
            return UIImage(named: "snowy")!
        } else if weather.range(of: "clear", options: .caseInsensitive) != nil {
            return UIImage(named: "clear")!
        } else{
            return UIImage(named: "other")!
        }

        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.allTodos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }



    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let cityToMove = self.allTodos[fromIndexPath.row]
        self.allTodos.remove(at: fromIndexPath.row)
        self.allTodos.insert(cityToMove, at: to.row)

    }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! DetailViewController
        let selectRow = tableView.indexPathForSelectedRow?.row
        
        destVC.theCity = self.allTodos[selectRow!].location.name
        destVC.theTemp = String(self.allTodos[selectRow!].current.tempF) + "°F"
        destVC.theWeather = String(self.allTodos[selectRow!].current.condition.text)
        destVC.localImage = self.getImg(weather: String(self.allTodos[selectRow!].current.condition.text))
    }


}



extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
