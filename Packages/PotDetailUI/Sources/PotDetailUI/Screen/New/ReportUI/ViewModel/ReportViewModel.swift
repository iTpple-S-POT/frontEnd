//
//  ReportViewModel.swift
//
//
//  Created by 최준영 on 3/5/24.
//

import Foundation
import GlobalObjects
import Alamofire

enum ReportTypeModel: CaseIterable {
    
    case type1
    case type2
    case type3
    case type4
    case type5
    case type6
    
    var koreanString: String {
        
        switch self {
        case .type1:
            "음란물 / 불법 촬영물 유통"
        case .type2:
            "유출 / 사칭 / 사기"
        case .type3:
            "욕설 / 비하"
        case .type4:
            "게시물 도배 / 속임수"
        case .type5:
            "부적절한 카테고리"
        case .type6:
            "기타 사항"
        }
    }
    
    var getRequestType: String {
        
        switch self {
        case .type1:
            "INAPPROPRIATE"
        case .type2:
            "SPAM"
        case .type3:
            "INAPPROPRIATE"
        case .type4:
            "SPAM"
        case .type5:
            "INAPPROPRIATE"
        case .type6:
            "OTHER"
        }
    }
}

class ReportViewModel: ObservableObject {
    
    @Published var reportType: ReportTypeModel?
    
    @Published var reportDetailString: String = ""
    
    @Published var reportResponseModel: ReportResponseModel?
    
    var apiRequester: ApiRequester
    
    var onReportPostRequestFailed: ((PotReportError) -> Void)?
    
    init(apiRequester: ApiRequester) {
        
        self.apiRequester = apiRequester
    }
    
    func postReportRequest(potId: Int) {
        
        guard let reportType = self.reportType else { return }
        
        let reportModel = ReportModel(
            reportType: reportType.getRequestType,
            reportContent: reportDetailString
        )
        
        
        apiRequester.sendReportToServer(potId: potId, dto: reportModel) { result in
            
            switch result {
            case .success(let success):
                
                self.reportResponseModel = success
            case .failure(let failure):
                
                print(failure.localizedDescription)

                self.onReportPostRequestFailed?(failure)
            }
        }
    }
}

extension APIRequestGlobalObject: ApiRequester {
    
    func sendReportToServer(potId: Int, dto: ReportModel, completion: @escaping (Result<ReportResponseModel, PotReportError>)->Void) {
        
        var url = URL(string: APIRequestGlobalObject.SpotAPI.baseUrl)!
        
        url = url.appendingPathComponent("api/v1/pot/\(potId)/report")
        
        guard var request = try? getURLRequest(url: url, method: .post, isAuth: true) else {
            
            return completion(.failure(.formRequestError))
        }
        
        guard let encoded = try? JSONEncoder().encode(dto) else {
            
            return completion(.failure(.formRequestError))
        }
        
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpRes = response as? HTTPURLResponse {
                
                if (200..<300).contains(httpRes.statusCode) {
                    
                    guard let resData = data, let decoded = try? JSONDecoder().decode(ReportResponseModel.self, from: resData) else {
                        
                        return completion(.failure(.decodingError))
                    }
                    
                    completion(.success(decoded))
                } else {
                    
                    if let resData = data, let decoded = try? JSONDecoder().decode(SpotErrorMessageModel.self, from: resData) {
                        
                        if decoded.code == 1704 {
                            
                            return completion(.failure(.cantReportMySelf))
                        }
                    }
                    completion(.failure(.apiRequestError))
                }
            }
            
        }.resume()
    }
}


