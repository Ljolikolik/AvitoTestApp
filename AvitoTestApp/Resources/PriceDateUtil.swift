//
//  PriceDateUtil.swift
//  AvitoTestApp
//
//  Created by Ольга Шовгенева on 31.08.2023.
//

import Foundation

public func formatDate(_ inputDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let date = dateFormatter.date(from: inputDate) else {
        return "Некорректный формат даты"
    }
    
    let outputDateFormatter = DateFormatter()
    outputDateFormatter.dateFormat = "dd MMMM, yyyy 'г.'"
    outputDateFormatter.locale = Locale(identifier: "ru_RU")
    
    return outputDateFormatter.string(from: date)
}

func formatPrice(_ inputPrice: String) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.groupingSeparator = " "
    numberFormatter.locale = Locale(identifier: "ru_RU")
    
    let cleanedPrice = inputPrice.replacingOccurrences(of: " ₽", with: "")
    
    if let numericValue = Double(cleanedPrice) {
        if let formattedValue = numberFormatter.string(from: NSNumber(value: numericValue)) {
            return "\(formattedValue) ₽"
        }
    }

    return "Некорректный формат цены"
}
