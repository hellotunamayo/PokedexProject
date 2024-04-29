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

//MARK: 일본어 전각 띄어쓰기를 반각 띄어쓰기로 변경 (지피티가 알려줬음)
extension String {
    func convertFullwidthToHalfwidth() -> String {
        let halfwidthSpace = "\u{0020}" // 반각 띄어쓰기
        let fullwidthSpace = "\u{3000}" // 전각 띄어쓰기
        
        let convertedString = self.map { char -> String in
            let charString = String(char) // 문자(Character)를 문자열(String)로 변환
            if charString == fullwidthSpace {
                return halfwidthSpace
            } else {
                return charString
            }
        }.joined()
        
        return convertedString
    }
}
