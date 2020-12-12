//
//  URLSessionFake.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 17/11/2020.
//

import Foundation
class URLSessionFake: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return returnTask(completionHandler)
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return returnTask(completionHandler)
    }
    
    func returnTask(_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
}

class WeatherURLSessionFake: URLSessionFake {
    var datas: [Data?]
    var times: Int = 0
    let failureInSecondTime: Bool
    init(failureInSecondTime: Bool, datas: [Data?], response: URLResponse?, error: Error?) {
        self.failureInSecondTime = failureInSecondTime
        self.datas = datas
        super.init(data: nil, response: response, error: error)
    }
    override func returnTask(_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.data = datas[times]
        times += 1
        task.completionHandler = completionHandler
        if times == 2 && failureInSecondTime {
            task.responseError = FakeResponseData.error
        } else {
            task.responseError = error
        }
        task.urlResponse = response
        return task
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    override func cancel() {}
}
