import Foundation

// NOTE: Ignoring async and Combine for now

let sessionDelegate: SessionDelegate? = SessionDelegate(label: "SessionDelegate", verbosity: .debug)
let taskDelegate: SessionDelegate? = SessionDelegate(label: "TaskDelegate", verbosity: .debug)
let sessionDelegateQueue = OperationQueue()
let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: sessionDelegateQueue)

/// Using https://github.com/postmanlabs/httpbin for http requests
///
/// To run locally:
/// ```
/// docker run -p 80:80 kennethreitz/httpbin
/// ```
let httpURL = URL(string: "http://localhost:80")!

/// Using https://github.com/jmalloc/echo-server for websocket requests
///
/// To run locally:
/// ```
/// docker run -p 10000:8080 jmalloc/echo-server
/// ```
let wsURL = URL(string: "ws://localhost:10000")!

// ===================================================================================
// Scratch pad >>>
// ===================================================================================

runUploadTaskFour()

// ===================================================================================
// <<< Scratch pad
// ===================================================================================

// MARK: - URLSessionDataTask

/// `URLSessionDataTask` (Option 1 of 4)
///
/// Delegate-based, accepts a `URLRequest`.
func runDataTaskOne() {

    let url = httpURL.appendingPathComponent("get")
    let request = URLRequest(url: url)

    let task = session.dataTask(with: request)
    task.delegate = taskDelegate
    task.resume()
}

/// `URLSessionDataTask` (Option 2 of 4)
///
/// Delegate-based, accepts a `URL`.
func runDataTaskTwo() {

    let url = httpURL.appendingPathComponent("get")

    let task = session.dataTask(with: url)
    task.delegate = taskDelegate
    task.resume()
}

/// `URLSessionDataTask` (Option 3 of 4)
///
/// Callback-based, accepts a `URLRequest`.
func runDataTaskThree() {

    let url = httpURL.appendingPathComponent("get")
    let request = URLRequest(url: url)

    session.dataTask(with: request) { _, _, _ in
        print("[\(Thread.current.number)] Task · completionHandler")
    }.resume()
}

/// `URLSessionDataTask` (Option 4 of 4)
///
/// Callback-based, accepts a `URL`.
func runDataTaskFour() {

    let url = httpURL.appendingPathComponent("get")

    session.dataTask(with: url) { _, _, _ in
        print("[\(Thread.current.number)] Task · completionHandler")
    }.resume()
}

// MARK: - URLSessionUploadTask

/// `URLSessionUploadTask` (Option 1 of 5)
///
/// Delegate-based, accepts a `URLRequest` and a local file `URL` to upload.
func runUploadTaskOne() {

    let url = httpURL.appendingPathComponent("anything")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let fileURL = Bundle.main.url(forResource: "150", withExtension: "png")!

    let task = session.uploadTask(with: request, fromFile: fileURL)
    task.delegate = taskDelegate
    task.resume()
}

/// `URLSessionUploadTask` (Option 2 of 5)
///
/// Delegate-based, accepts a `URLRequest` and the in-memory `Data` to upload.
func runUploadTaskTwo() {

    let url = httpURL.appendingPathComponent("post")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let fileURL = Bundle.main.url(forResource: "150", withExtension: "png")!
    let fileData = try! Data(contentsOf: fileURL)

    let task = session.uploadTask(with: request, from: fileData)
    task.delegate = taskDelegate
    task.resume()
}

/// `URLSessionUploadTask` (Option 3 of 5)
///
/// Delegate-based, accepts a `URLRequest`. The request's `httpBody` holds the data to upload.
func runUploadTaskThree() {

    let url = httpURL.appendingPathComponent("post")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let fileURL = Bundle.main.url(forResource: "150", withExtension: "png")!
    request.httpBody = try! Data(contentsOf: fileURL)

    let task = session.uploadTask(withStreamedRequest: request)
    task.delegate = taskDelegate
    task.resume()
}

/// `URLSessionUploadTask` (Option 4 of 5)
///
/// Callback-based, accepts a `URLRequest` and a local file `URL` to upload.
func runUploadTaskFour() {

    let url = httpURL.appendingPathComponent("post")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let fileURL = Bundle.main.url(forResource: "150", withExtension: "png")!

    session.uploadTask(with: request, fromFile: fileURL) { data, urlResponse, error in
        print("[\(Thread.current.number)] Task · completionHandler")

        let bodyStr = String(data: data!, encoding: .utf8)
        print("[RP] bodyStr: \(String(describing: bodyStr))")
    }.resume()
}

/// `URLSessionUploadTask` (Option 5 of 5)
///
/// Callback-based, accepts a `URLRequest` and the in-memory `Data` to upload.
func runUploadTaskFive() {

    let url = httpURL.appendingPathComponent("post")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let fileURL = Bundle.main.url(forResource: "150", withExtension: "png")!
    let fileData = try! Data(contentsOf: fileURL)

    session.uploadTask(with: request, from: fileData) { _, _, _ in
        print("[\(Thread.current.number)] Task · completionHandler")
    }.resume()
}

// MARK: - URLSessionDownloadTask

/// `URLSessionDownloadTask` (Option 1 of 6)
///
/// Delegate-based, accepts a `URLRequest`
func runDownloadTaskOne() {

    let url = httpURL.appendingPathComponent("image/jpeg")
    let request = URLRequest(url: url)

    let task = session.downloadTask(with: request)
    task.delegate = taskDelegate
    task.resume()
}

/// `URLSessionDownloadTask` (Option 2 of 6)
///
/// Delegate-based, accepts a `URL`
func runDownloadTaskTwo() {

    let url = httpURL.appendingPathComponent("image/jpeg")

    let task = session.downloadTask(with: url)
    task.delegate = taskDelegate
    task.resume()
}

/// `URLSessionDownloadTask` (Option 3 of 6)
///
/// Delegate-based, accepts resumable `Data`
func runDownloadTaskThree() {

    let data = Data()

    let task = session.downloadTask(withResumeData: data)
    task.delegate = taskDelegate
    task.resume()
}

/// `URLSessionDownloadTask` (Option 4 of 6)
///
/// Callback-based, accepts a `URLRequest`
func runDownloadTaskFour() {

    let url = httpURL.appendingPathComponent("image/jpeg")
    let request = URLRequest(url: url)

    session.downloadTask(with: request) { _, _, _ in
        print("[\(Thread.current.number)] Task · completionHandler")
    }.resume()
}

/// `URLSessionDownloadTask` (Option 5 of 6)
///
/// Callback-based, accepts a `URL`
func runDownloadTaskFive() {

    let url = httpURL.appendingPathComponent("image/jpeg")

    session.downloadTask(with: url) { _, _, _ in
        print("[\(Thread.current.number)] Task · completionHandler")
    }.resume()
}

/// `URLSessionDownloadTask` (Option 6 of 6)
///
/// Callback-based, accepts resumable `Data`
func runDownloadTaskSix() {

    let data = Data()

    session.downloadTask(withResumeData: data) { _, _, _ in
        print("[\(Thread.current.number)] Task · completionHandler")
    }.resume()
}

// MARK: - URLSessionStreamTask

/// `URLSessionStreamTask` (Option 1 of 1)
///
/// Delegate-based, accepts host name as a `String` and port as an `Int`.
func runStreamTaskOne() {

    let task = session.streamTask(withHostName: httpURL.absoluteString, port: 80)
    task.delegate = taskDelegate
    task.resume()
}

// MARK: - URLSessionWebSocketTask

/// `URLSessionWebSocketTask` (Option 1 of 3)
///
/// Delegate-based, accepts `URL`
func runWebSocketTaskOne() {

    let task = session.webSocketTask(with: wsURL)
    task.delegate = taskDelegate
    task.resume()

    for i in 0..<10 {
        DispatchQueue.global().asyncAfter(deadline: .now() + (Double(i) * 0.1)) {
            let message = "Message \(i)"
            print("Will send '\(message)'")
            task.send(.string(message)) { err in
                print("Did send '\(message)'. Error: \(String(describing: err)).")
            }
        }
    }
}

/// `URLSessionWebSocketTask` (Option 2 of 3)
///
/// Delegate-based, accepts `URL` and array of protocol strings.
func runWebSocketTaskTwo(session: URLSession) {

    let task = session.webSocketTask(with: wsURL, protocols: [])
    task.delegate = taskDelegate
    task.resume()

    for i in 0..<10 {
        DispatchQueue.global().asyncAfter(deadline: .now() + (Double(i) * 0.1)) {
            let message = "Message \(i)"
            print("Will send '\(message)'")
            task.send(.string(message)) { err in
                print("Did send '\(message)'. Error: \(String(describing: err)).")
            }
        }
    }
}

/// `URLSessionWebSocketTask` (Option 3 of 3)
///
/// Delegate-based, accepts `URLRequest`.
func runWebSocketTaskThree(session: URLSession) {

    var request = URLRequest(url: wsURL)
    request.timeoutInterval = 5

    let task = session.webSocketTask(with: request)
    task.delegate = taskDelegate
    task.resume()

    for i in 0..<10 {
        DispatchQueue.global().asyncAfter(deadline: .now() + (Double(i) * 0.1)) {
            let message = "Message \(i)"
            print("Will send '\(message)'")
            task.send(.string(message)) { err in
                print("Did send '\(message)'. Error: \(String(describing: err)).")
            }
        }
    }
}
