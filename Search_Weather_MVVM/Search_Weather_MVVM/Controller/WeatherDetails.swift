//
//  WeatherDetails.swift
//  Search_Weather_MVVM
//
//  Created by Mihin  Patel on 23/03/21.
//

import UIKit

class WeatherDetails: UIViewController {


    @IBOutlet var viewContainer: UIView!
    @IBOutlet var ivIcon: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    
    var weatherForecast:WeatherForecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let weather = weatherForecast?.weather{
            if(!weather.isEmpty){
                lblDescription.text = weather.count>0 ? weather[0].main : "N/A"
                let icnURL:String = WS_Iconurl + API.Icon.rawValue + "\(weather[0].icon ?? "")@2x.png"
                ivIcon.setImage(withURL: icnURL, AndPlaceholder: UIImage(named: "place_holder"), completion: nil)
                ivIcon.setCornerRadius(cornerRadius: 10)
            }else{
                lblDescription.text =  "N/A"
            }
        }
        
        lblMaxTemp.text = "\((weatherForecast?.main?.temp_max)! - 273.15)"
        lblMinTemp.text = "\((weatherForecast?.main?.temp_min)! - 273.15)"
        lblWindSpeed.text = "\(weatherForecast?.wind?.speed ?? 0)"
        viewContainer.setCornerRadiusView(cornerRadius: 10)
    }
    
    @IBAction func actionCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
