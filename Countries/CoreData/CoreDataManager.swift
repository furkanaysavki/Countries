//
//  CoreDataManager.swift
//  Countries
//
//  Created by Furkan Ayşavkı on 25.10.2022.
//

import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()
    var coreDataStack: CoreDataStack
    var moc: NSManagedObjectContext {
        return coreDataStack.managedContext
    }

    private init(coreDataStack: CoreDataStack = CoreDataStack(modelName: "Countries")) {
        self.coreDataStack = coreDataStack
    }

    private func countryIDPredicate(of request: NSFetchRequest<Countries>, with id: String) -> NSPredicate {
        request.predicate = NSPredicate(format: "code == %@", id)
        return request.predicate!
    }

    func checkIsFavourite(with countryID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            let request: NSFetchRequest<Countries> = Countries.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = countryIDPredicate(of: request, with: countryID)
            let fetchedResults = try moc.fetch(request)
            fetchedResults.first != nil ? completion(.success(true)) : completion(.success(false))
        } catch {
            completion(.failure(error))
        }
    }

    func getCountriesFromPersistance(completion: @escaping (Result<[Countries], Error>) -> Void) {
        do {
            let request: NSFetchRequest<Countries> = Countries.fetchRequest()
            request.returnsObjectsAsFaults = false
            let countries = try moc.fetch(request)
            completion(.success(countries))
        } catch {
            completion(.failure(error))
        }
    }

    func createFavouriteCountry(with model: Country) {
        let Country = Countries(context: moc)
        Country.code = model.code
        Country.name = model.name
        coreDataStack.saveContext()
    }

    func deleteMovie(with countryID: String, completion: @escaping (Error) -> Void) {
        let request: NSFetchRequest<Countries> = Countries.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = countryIDPredicate(of: request, with: countryID)
        do {
            let fetchedResult = try moc.fetch(request)
            if let countryModel = fetchedResult.first {
                moc.delete(countryModel)
                coreDataStack.saveContext()
            }
        } catch {
            completion(error)
        }
    }
}
