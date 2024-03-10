//
//  File.swift
//  
//
//  Created by 최준영 on 3/5/24.
//

import Foundation

enum PotReportError: Error {
    
    case formRequestError
    case apiRequestError
    case decodingError
    case cantReportMySelf
}

protocol ApiRequester {
    
    func sendReportToServer(potId: Int, dto: ReportModel, completion: @escaping (Result<ReportResponseModel, PotReportError>)->Void)
}
