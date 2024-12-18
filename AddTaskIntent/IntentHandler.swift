////
////  IntentHandler.swift
////  AddTaskIntent
////
////  Created by Bekhruzjon Hakmirzaev on 16/12/24.
////
//
//import Intents
//import SwiftData
//
//class IntentHandler: INExtension {
//    
//    override func handler(for intent: INIntent) -> Any {
//        // This is the default implementation.  If you want different objects to handle different intents,
//        // you can override this and return the handler you want for that particular intent.
//        
//        guard intent is AddTaskIntent else {
//            fatalError("Unhandled intent error: \(intent)")
//        }
//        
//        return self
//    }
//    
//}
//
//class AddTaskIntentHandler: NSObject, AddTaskIntentHandling {
//    
//    func handle(intent: AddTaskIntent, completion: @escaping (AddTaskIntentResponse) -> Void) {
//        if let name = intent.taskname {
//            
//            completion(AddTaskIntentResponse.success(taskname: name))
//        }
//    }
//    
//    func resolveTaskname(for intent: AddTaskIntent, with completion: @escaping (AddTaskTasknameResolutionResult) -> Void) {
//        guard let name = intent.taskname else {
//            completion(AddTaskTasknameResolutionResult.needsValue())
//            return
//        }
//        
//        completion(AddTaskTasknameResolutionResult.success(with: name))
//    }
//    
//    func addTask(name: String) {
//        var data: [String] = []
//        
//        
//    }
//}
