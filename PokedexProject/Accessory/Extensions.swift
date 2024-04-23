//
//  Extensions.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/23/24.
//

import Foundation

//MARK: Index out of range 해결
//reference: https://stackoverflow.com/questions/37222811/how-do-i-catch-index-out-of-range-in-swift
extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
