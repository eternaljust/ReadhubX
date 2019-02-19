import Foundation
import Alamofire

open class NetworkService<T: Codable> {
    
    typealias CompletionJSONClosure = (_ data: T?, _ message: String?, _ success: Bool) -> Void
    var completionJSONClosure:CompletionJSONClosure =  {_,_,_  in }
    
    init() {
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = 10
    }
    
    // JSON 的请求
    func requestJSON(url: String,
                     doneClosure:@escaping CompletionJSONClosure
        ) {
        self.completionJSONClosure = doneClosure
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        Alamofire.request(url).responseData { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let jsonModel = try decoder.decode(T.self, from: data)
                    
                    self.completionJSONClosure(jsonModel, "成功！", true)
                } catch {
                    self.completionJSONClosure(nil, "数据错误！", false)
                }
            } else {
                self.completionJSONClosure(nil, response.error?.localizedDescription, false)
            }
        }
    }
}
