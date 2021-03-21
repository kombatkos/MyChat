//
//  ProfileService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 14.03.2021.
//

import Foundation

protocol ProfileService: class {
    func saveProfile(profile: Profile, completion: @escaping (Bool) -> Void)
    func loadProfile(completion: @escaping (Profile?) -> Void)
    func cancel()
}
