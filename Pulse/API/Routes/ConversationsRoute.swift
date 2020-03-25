//
//  Conversations.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Foundation
import Alamofire

class ConversationsRoute : BaseRoute {
    
    init() {
        super.init(route: "conversations")
    }
    
    func latestTimestamp(completionHandler: @escaping (Int64) -> Void) {
        if !Account.exists() {
            return
        }
        
        get(path: "/latest_timestamp").responseString { response in
            do {
                let timestamp = try response.result.get()
                completionHandler(Int64(timestamp)!)
            } catch { }
        }
    }
    
    func getUnarchived(completionHandler: @escaping ([Conversation]) -> Void) {
        if !Account.exists() {
            return
        }
        
        get(path: "/index_unarchived", parameters: ["account_id": Account.accountId!, "limit": 100]).responseCollection(completionHandler: completionHandler)
    }
    
    func getArchived(completionHandler: @escaping ([Conversation]) -> Void) {
        if !Account.exists() {
            return
        }
        
        get(path: "/index_archived", parameters: ["account_id": Account.accountId!, "limit": 100]).responseCollection(completionHandler: completionHandler)
    }
    
    func updateSnippet(conversation: Conversation, snippet: String) {
        post(path: "/update/\(conversation.id)", parameters: [
            "account_id": Account.accountId!, "read": true, "timestamp": Date().millisecondsSince1970,
            "snippet": Account.encryptionUtils!.encrypt(data: snippet)
        ])
    }
    
    func archive(conversation: Conversation) {
        post(path: "/archive/\(conversation.id)")
    }
    
    func unarchive(conversation: Conversation) {
        post(path: "/unarchive/\(conversation.id)")
    }
    
    func delete(conversation: Conversation) {
        post(path: "/remove/\(conversation.id)")
    }
    
    func read(conversation: Conversation) {
        post(path: "/read/\(conversation.id)")
    }
}
