//
//  TipsModels.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 28.08.2022.
//

import Foundation

struct Tip: Decodable {
   let id: String?
   let created_at: String?
   let text: String?
}

extension Tip {
    func dateText() -> String {
        return String(created_at?.split(separator: "T").first ?? "no date")
    }
}


typealias Tips = [Tip]

/*
{
    "id": "54d9e860498e24f3444f3ae7",
    "created_at": "2015-02-10T11:15:44.000Z",
    "text": "Быстрое и приятное обслуживание!"
}
*/
