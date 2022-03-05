//
//  DetailViewController.swift
//  live_weatherAPP
//
//  Created by Youzhi Liang on 2/19/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    

    @IBOutlet weak var cityImage: UIImageView!
    
    
    @IBOutlet weak var cityName: UILabel!
    
    

    @IBOutlet weak var cityDescription: UITextField!
    
    var localImage : UIImage!
    var theCity : String!
    var theTemp :String!
    var theWeather :String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        cityName.text = theCity
        cityImage.image = localImage
        //cityDescription.text = theDescription
        cityDescription.text = "In" + " \(theCity as String), it's \(theTemp as String) with \(theWeather as String) weather.".lowercased()
        //cityDescription.text = "In " + theCity + ", it's " + theTemp " with " + theWeather " weather."

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
