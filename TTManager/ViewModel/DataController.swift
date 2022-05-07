//
//  DataController.swift
//  TTManager
//
//  Created by Alex Wecker on 28/12/2021.
//

import Foundation
import CoreData

class DataController : ObservableObject{
    
    //defining the container for the database
    let container = NSPersistentContainer(name: "TTClub")
    private var clubs: [Club] = []{
        didSet{
            filterClub()
        }
    }
    @Published var filteredclubs: [Club] = []
    private var players: [Player] = []{
        didSet{
            filterPlayer()
        }
    }
    @Published var filteredPlayer: [Player] = []
    @Published var matches: [Match] = []
    @Published var matchesday: [Match] = []
    @Published var matchesSinglePlayer: [Match] = []
    let networkManager = NetworkManager()
    
    init() {
        // load all the data from the container and complete the construction of the Core Data Stack
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("ERROR during loading the data from Core Data with error: " + error.localizedDescription)
                return
            }else{
                print("Database loaded")
                //init the clubs
                self.fetchClub()
                if (self.clubs.count == 0) {
                    self.initClubData()
                }
                //init the filtered list of Clubs
                self.filterClub()
                
                // init the players on the NPR
                self.fetchPlayer()
                if (self.players.count == 0){
                    //NPR is empty
                    //initialize the NPR (downloading)
                    self.initNPRData()
                    //Save the time of the last Api lookup
                    UserDefaults.standard.set(Date().description.prefix(10), forKey: "lastDownloadedNPR")
                }else{
                    //check if new NPR is available
                    self.networkManager.checkNPR(lastCheck: UserDefaults.standard.string(forKey: "lastDownloadedNPR")!,
                                            complHandler: {
                                                //remove old NPR and load new NPR
                                                self.removeNPR()
                                                self.initNPRData()
                                            })
                    //self.initNPRData()
                }
                self.filterPlayer()
                
                //init Matches
                self.fetchMatch()
                if let lastLookup =  UserDefaults.standard.string(forKey: "lastLookup"){
                    print("Last Lookup, \(lastLookup)")
                    //load new matches
                    self.networkManager.loadMatches(licenseNumber: UserDefaults.standard.string(forKey: "licenceNumber")!,
                                               lastUpdate: lastLookup,
                                               handler: self.addMatch)
                }
                self.fetchMatch()
            }
        }
    }
    
    func fetchClub() {
        let request = NSFetchRequest<Club>(entityName: "Club")
        do {
            clubs = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching the clubs from Club")
            print(error)
        }
    }
    
    func fetchPlayer() {
        let request = NSFetchRequest<Player>(entityName: "Player")
        do {
            players = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching the clubs from Player")
            print(error)
        }
    }
    
    func fetchMatch() {
        let request = NSFetchRequest<Match>(entityName: "Match")
        do {
            matches = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching the clubs from Player")
            print(error)
        }
    }
    
    func filterClub(filter: String = "") {
        let request = NSFetchRequest<Club>(entityName: "Club")
        if filter != "" {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", filter)
            request.predicate = predicate
        }
        do {
            filteredclubs = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching the clubs from Club:")
            print(error)
        }
    }
    
    func filterPlayer(namefilter: String? = nil,clubfilter: String? = nil,playerClassfilter: String? = nil) {
        //filter the Players on the NPR
        let request = NSFetchRequest<Player>(entityName: "Player")
        var predicateArray = [NSPredicate]()
        //Are there some filter applyed?
        var isFiltered = false
        //check if the name should be filtered
        if namefilter != nil && namefilter! != "" {
            //add the name predicate to the predicate array
            predicateArray.append(NSPredicate(format: "name CONTAINS[c] %@", namefilter!))
            isFiltered = true
        }
        //should the club be filtered
        if clubfilter != nil && clubfilter! != ""  {
            //add the club predicate to the predicate array
            predicateArray.append(NSPredicate(format: "club == %@", clubfilter!))
            isFiltered = true
        }
        //should the class be filtered
        if playerClassfilter != nil && playerClassfilter! != ""  {
            //add the class predicate to the predicate array
            predicateArray.append(NSPredicate(format: "playerClass == %@", playerClassfilter!))
            isFiltered = true
        }
        //if there are some filters, apply them
        if isFiltered {
            request.predicate = NSCompoundPredicate(type: .or ,subpredicates: predicateArray)
        }
        do {
            //update filteredPlayer with database reply
            filteredPlayer = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching the clubs from Player")
            print(error)
        }
    }
    
    func filterMatch(filterDay: String,filterPlayer: String) {
        let request = NSFetchRequest<Match>(entityName: "Match")
        
        //get all matches where the given player is involved
        if filterPlayer != "" {
            let predicate = NSPredicate(format: "nameOther == %@", filterPlayer)
            request.predicate = predicate
        }
        do {
            //update matchesSinglePlayer with database reply
            matchesSinglePlayer = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching the matches from Match:")
            print(error)
        }
        
        //get all matches played that day
        if filterDay != "" {
            let predicate = NSPredicate(format: "day == %@", filterDay)
            request.predicate = predicate
        }
        do {
            //update matchesday with database reply
            matchesday = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR fetching the matches from Match:")
            print(error)
        }
        
        
    }
    
    func initClubData() {
        //insert the club data into the database
        addClub(name: "Medernach", address: "Address Medernach", phonenumber: "352691123456", latitude: 49.8088921, longitude: 6.2146186)
        addClub(name: "Nommern", address: "Address Nommern", phonenumber: "352691654321", latitude: 49.9088921, longitude: 6.2006186)
    }
    
    func initNPRData() {
        players = []
        networkManager.performrequest(){ranking, name, club, playerClass in
            self.addPlayer(ranking: ranking, name: name, club: club, playerClass: playerClass)
        }
        
    }
    
    func initMatchesData() {
        fetchMatch()
        //remove matches if there are any
        removeMatches()
        //download the matches from the API
        networkManager.loadMatches(licenseNumber: UserDefaults.standard.string(forKey: "licenceNumber") ?? "", handler: addMatch)
    }
    
    func addClub(name: String, address: String, phonenumber: String, latitude: Double, longitude: Double) {
        let newclub = Club(context: container.viewContext)
        
        //add the data to the club
        newclub.address = address
        newclub.images = ""
        newclub.name = name
        newclub.phonenumber = phonenumber
        newclub.latitude = latitude
        newclub.longitude = longitude
        //save in CoreData
        saveData()
    }
    
    func addMatch(date: String,competition: String,day: String,match: String,classOther: String,points: String,score: String,classSelf: String,nameOther: String) {
        let newMatch = Match(context: container.viewContext)
        
        //add the data to the match
        newMatch.date = date
        newMatch.competition = competition
        newMatch.day = day
        newMatch.match = match
        newMatch.classOther = classOther
        newMatch.points = points
        newMatch.score = score
        newMatch.classSelf = classSelf
        newMatch.nameOther = nameOther
        //save in CoreData
        saveData()
    }
    
    func addPlayer(ranking: String, name: String, club: String, playerClass: String) {
        let newPlayer = Player(context: container.viewContext)
        
        //add the data to the player
        newPlayer.ranking = ranking
        newPlayer.name = name
        newPlayer.club = club
        newPlayer.playerClass = playerClass
        //save the context
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchClub()
            fetchPlayer()
            fetchMatch()
        } catch {
            print("Error saving the context!!")
        }
        
    }
    
    func removeMatches() {
        removeTableContent(tableName: "Match")
    }
    
    func removeNPR() {
        removeTableContent(tableName: "Player")
    }
    
    func removeTableContent(tableName: String) {
        //delete everything from a table
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tableName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
        } catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
    }
    
}

