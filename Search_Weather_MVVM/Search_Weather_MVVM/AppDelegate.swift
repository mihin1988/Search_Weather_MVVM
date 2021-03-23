//
//  AppDelegate.swift
//  Search_Weather_MVVM
//
//  Created by Mihin  Patel on 21/03/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var cityList: [NSManagedObject] = []
    var arrList : [List] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.prepareCityList()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    func prepareCityList(){
        
        self.readLocalFile(forName: "city_list"){ (City_List,message:String) in
            if let list = City_List.list{
                print(list.count)
                self.arrList = list
//                self.insertCity(list: self.arrList)
            }
        }
        
//        print("==>\(self.cityList.count)")
//        self.retriveCityList()
    }
    
    func insertCity(list:[List])
    {
                let managedContext = self.persistentContainer.viewContext

                let city_List = NSEntityDescription.entity(forEntityName: "CityList", in: managedContext)!

                for i in 0...10{
                    let city = NSManagedObject(entity: city_List, insertInto: managedContext)
                    city.setValue(list[i].id, forKeyPath: "id")
                    city.setValue(list[i].name, forKeyPath: "name")
                    city.setValue(list[i].state, forKeyPath: "state")
                    city.setValue(list[i].country, forKeyPath: "country")
                    city.setValue(list[i].last_updated, forKeyPath: "last_updated")
                    city.setValue(list[i].is_favorite, forKeyPath: "is_favorite")

                    do {
                        try managedContext.save()
                        self.cityList.append(city)
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
    }
    func retriveCityList(){
        self.cityList = []
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CityList")
        
        //3"
        do {
            self.cityList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for i in 0...self.cityList.count-1{
            let list = self.cityList[i]
            print(list.value(forKeyPath: "name") as? String ?? "")
        }
    }
    
    func readLocalFile(forName name: String,completionHandler : @escaping (City_List,String) -> Void) {
        let jsonDecoder = JSONDecoder()
        do {
            
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let responseModel = try jsonDecoder.decode(City_List.self, from: jsonData)
                //                 print(responseModel)
                if(responseModel.list?.count ?? 0>0){
                    completionHandler(responseModel,"Loadded Successfully!")
                }else{
                    completionHandler(responseModel,"Something Went Wrong ")
                }
            }
        } catch {
            print(error)
        }
        
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Search_Weather_MVVM")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

