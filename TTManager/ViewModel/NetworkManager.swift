//
//  NetworkManager.swift
//  TTManager
//
//  Created by Alex Wecker on 08/01/2022.
//

import Foundation

struct NetworkManager {
    
    private let server = "192.168.131.233"
//    private let server = "localhost"
    private let port = 10030
    
    func performrequest(handler: @escaping (String,String,String,String) -> Void){
        //build URL
        let urlString = "http://" + server + ":" + port.description + "/" + "NPR"
        // -1- Create URL(originally based on the string from openweathermap.com)
        if let url = URL(string: urlString){
            // -2- create a URLSession (this job is originally done by the browser)
            let session = URLSession(configuration: .default)
            // -3- give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {return}
                if let saveData = data{
                    parsePlayerJSON(jsonData: saveData,handler: handler)
                    //save the time the NPR was downloaded
                    UserDefaults.standard.set(Date().description.prefix(10), forKey: "lastDownloadedNPR")
                }
            }
            // -4- Start the task
            task.resume()
        }
    }
    
    func checkNPR(lastCheck : String,complHandler: @escaping () -> Void){
        //build URL
        var urlString = "http://" + server + ":" + port.description + "/" + "NPR" + "/" + lastCheck.prefix(10)
        // -1- Create URL(originally based on the string from openweathermap.com)
        if let url = URL(string: urlString){
            // -2- create a URLSession (this job is originally done by the browser)
            let session = URLSession(configuration: .default)
            // -3- give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {return}
                if let saveData = data{
                    if let dataString =  String(bytes: saveData, encoding: .utf8){
                        if dataString == "true" {
                            DispatchQueue.main.async {
                                //there is a new NPR available
                                complHandler()
                            }
                        }
                    }
                }
            }
            // -4- Start the task
            task.resume()
        }
    }
    
    private func parsePlayerJSON(jsonData: Data, handler: @escaping (String,String,String,String) -> Void){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([PlayerData].self, from: jsonData)
            DispatchQueue.main.async {
                for player in decodedData {
                    //enter each row in the handler
                    handler(player.ranking, player.name, player.club, player.playerClass)
                }
            }
        }catch{
            print(error)
        }
    }
    
    func performlookup(method: String,info: String , handler: @escaping (PlayerInformation) -> Void){
        //build the URL String using the server address and port, append the API endpoint and append data
        let urlString = "http://" + server + ":" + port.description + "/" + method + "/" + info.replacingOccurrences(of: " ", with: "_")
        // -1- Create URL
        if let url = URL(string: urlString){
            // -2- create a URLSession (this job is originally done by the browser)
            let session = URLSession(configuration: .default)
            // -3- give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {return}
                if let saveData = data{
                    parseInfoJSON(jsonData: saveData,handler: handler)
                }
            }
            // -4- Start the task
            task.resume()
        }
    }
    
    private func parseInfoJSON(jsonData: Data, handler: @escaping (PlayerInformation) -> Void){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(PlayerInformation.self, from: jsonData)
            DispatchQueue.main.async {
                handler(decodedData)
            }
        }catch{
            print(error)
        }
    }
    
    func loadMatches(licenseNumber: String,lastUpdate: String? = nil, handler: @escaping (String,String,String,String,String,String,String,String,String) -> Void){
        //build the URL String using the server address and port, append the API endpoint and append data
        var urlString = "http://" + server + ":" + port.description + "/Matches" + "/" + licenseNumber.replacingOccurrences(of: " ", with: "_")
        if let additionalData = lastUpdate {
            //append the last lookup date so only new Matches will be retrieved
            urlString = urlString + "/" + additionalData.prefix(10)
        }
        // -1- Create URL(originally based on the string from openweathermap.com)
        if let url = URL(string: urlString){
            // -2- create a URLSession (this job is originally done by the browser)
            let session = URLSession(configuration: .default)
            // -3- give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {return}
                if let saveData = data{
                    parseMatch(jsonData: saveData,handler: handler)
                }
            }
            // -4- Start the task
            task.resume()
        }
    }
    
    private func parseMatch(jsonData: Data, handler: @escaping (String,String,String,String,String,String,String,String,String) -> Void){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([Match].self, from: jsonData)
            DispatchQueue.main.async {
                for match in decodedData {
                    //enter the data in the handler
                    handler(match.date,
                            match.competition,
                            match.day,
                            match.match,
                            match.classOther,
                            match.points,
                            match.score,
                            match.classSelf,
                            match.nameOther)
                }
            }
        }catch{
            print(error)
        }
    }
    
    struct PlayerData: Decodable {
        let ranking: String
        let name: String
        let club: String
        let playerClass: String
    }
    
    struct Match: Decodable {
        let date: String
        let competition: String
        let day: String
        let match: String
        let classOther: String
        let points: String
        let score: String
        let classSelf: String
        let nameOther: String
    }
}
