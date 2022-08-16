import Foundation

public final class SessionDelegate: NSObject {

    let label: String
    let verbosity: LogVerbosity

    public init(label: String, verbosity: LogVerbosity) {
        self.label = label
        self.verbosity = verbosity
    }

    private func printFunctionEntry(_ arguments: [String: String] = [:], function: StaticString = #function) {
        guard verbosity > .off else {
            return
        }
        print("\n[\(Thread.current.number)] \(label).\(function)")
        guard (verbosity > .info) && !arguments.isEmpty else {
            return
        }
        print("\n  Arguments:")
        for (key, val) in arguments {
            let valLines = val.components(separatedBy: "\n")
            if valLines.count > 1 {
                print("    - \(key):")
                print(valLines.compactMap({ $0.isEmpty ? nil : "      | \($0)" }).joined(separator: "\n"))
            } else {
                print("    - \(key): \(val)")
            }

        }
    }
}

extension SessionDelegate: URLSessionDelegate {

    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        printFunctionEntry([
            "error": (error as NSError?)?.debugDescription ?? "nil"
        ])
    }

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        printFunctionEntry([
            "challenge": challenge.debugDescription
        ])
        completionHandler(.performDefaultHandling, nil)
    }

    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        printFunctionEntry()
    }
}

extension SessionDelegate: URLSessionTaskDelegate {

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willBeginDelayedRequest request: URLRequest,
        completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void
    ) {
        printFunctionEntry([
            "task": task.debugDescription,
            "request": request.debugDescription
        ])
        completionHandler(.continueLoading, request)
    }

    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        printFunctionEntry([
            "task": task.debugDescription
        ])
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        printFunctionEntry([
            "task": task.debugDescription,
            "response": response.debugDescription,
            "request": request.debugDescription
        ])
        completionHandler(request)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        printFunctionEntry([
            "task": task.debugDescription,
            "challenge": challenge.debugDescription
        ])
        completionHandler(.performDefaultHandling, nil)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Void
    ) {
        printFunctionEntry([
            "task": task.debugDescription
        ])
        completionHandler(nil)
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        printFunctionEntry([
            "task": task.debugDescription,
            "bytesSent": bytesSent.description,
            "totalBytesSent": totalBytesSent.description,
            "totalBytesExpectedToSend": totalBytesExpectedToSend.description
        ])
    }

    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didFinishCollecting metrics: URLSessionTaskMetrics
    ) {
        printFunctionEntry([
            "task": task.debugDescription,
            "metrics": metrics.debugDescription
        ])
    }


    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        printFunctionEntry([
            "task": task.debugDescription,
            "error": (error as NSError?)?.debugDescription ?? "nil"
        ])
    }
}

extension SessionDelegate: URLSessionDataDelegate {

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        printFunctionEntry([
            "dataTask": dataTask.debugDescription,
            "response": response.debugDescription
        ])
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask
    ) {
        printFunctionEntry([
            "dataTask": dataTask.debugDescription,
            "downloadTask": downloadTask.debugDescription
        ])
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome streamTask: URLSessionStreamTask
    ) {
        printFunctionEntry([
            "dataTask": dataTask.debugDescription,
            "streamTask": streamTask.debugDescription
        ])
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        printFunctionEntry([
            "dataTask": dataTask.debugDescription
        ])
    }

    public func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void
    ) {
        printFunctionEntry([
            "dataTask": dataTask.debugDescription
        ])
    }
}

extension SessionDelegate: URLSessionDownloadDelegate {

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        printFunctionEntry([
            "downloadTask": downloadTask.debugDescription
        ])
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        printFunctionEntry([
            "downloadTask": downloadTask.debugDescription
        ])
    }

    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64
    ) {
        printFunctionEntry([
            "downloadTask": downloadTask.debugDescription
        ])
    }
}

extension SessionDelegate: URLSessionStreamDelegate {

    public func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        printFunctionEntry([
            "streamTask": streamTask.debugDescription
        ])
    }

    public func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        printFunctionEntry([
            "streamTask": streamTask.debugDescription
        ])
    }

    public func urlSession(
        _ session: URLSession,
        betterRouteDiscoveredFor streamTask: URLSessionStreamTask
    ) {
        printFunctionEntry([
            "streamTask": streamTask.debugDescription
        ])
    }

    public func urlSession(
        _ session: URLSession,
        streamTask: URLSessionStreamTask,
        didBecome inputStream: InputStream,
        outputStream: OutputStream
    ) {
        printFunctionEntry([
            "streamTask": streamTask.debugDescription,
            "inputStream": inputStream.debugDescription,
            "outputStream": outputStream.debugDescription
        ])
    }
}

extension SessionDelegate: URLSessionWebSocketDelegate {
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocolName: String?
    ) {
        printFunctionEntry([
            "webSocketTask": webSocketTask.debugDescription,
            "protocol": protocolName ?? "nil"
        ])
    }

    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        printFunctionEntry([
            "webSocketTask": webSocketTask.debugDescription,
            "closeCode": "\(closeCode.rawValue)",
            "reason": String(describing: reason?.count)
        ])
    }
}
