//
//  CityViewModel.swift
//  Search_Weather_MVVM
//
//  Created by Mihin  Patel on 23/03/21.
//

import Foundation

class CityViewModel: NSObject {
    
//    var cityID : Int!

    private(set) var watherData : WeatherForecast! {
        didSet {
            self.bindCityViewModelToController()
        }
    }
    
    var bindCityViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
    }
    
    
    //MARK: - APICall
    
    func callAPIForGetWeather(cityId:Int) {
        Webservice().getWeather(requestParam: "id=\(cityId)&appid=\(openWeatherMapAPIKey)"){ (responseModel) in
            if(responseModel.cod == 200){
                print(responseModel)
                self.watherData = responseModel
            }
        }
    }
}
