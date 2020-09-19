//
//  JavaScriptExecutor.swift
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

import JavaScriptCore

class JSError: Error {
  
}
class JavaScriptExecutor {

    lazy var jsContext = { () -> JSContext? in
        let jsVirtualMachine = JSVirtualMachine()
        let context = JSContext(virtualMachine: jsVirtualMachine)
        context?.setObject(JSLogger.self, forKeyedSubscript: "JSLogger" as NSString)
        return context
    }()
    // exception from JavaScript
    var exception = ""

    private init() {}

    static func getFullFilePath(fileName:String) -> String {
        return Bundle.main.path(forResource: fileName, ofType: nil) ?? "\(fileName)"
    }

    convenience init(jsFileName: String) {
        let jsFilePath = JavaScriptExecutor.getFullFilePath(fileName: jsFileName)
        self.init(jsFilePath: jsFilePath)
    }

    init(jsSource: String) {
        setupJSSource(jsSource: jsSource)
    }

     init(jsFilePath: String) {
        do {
            let jsSource = try String(contentsOfFile: jsFilePath)
            setupJSSource(jsSource: jsSource)
        } catch {
            print(error)
            // TODO: Handle the error
        }
    }

    // Load multiple js files
    init(jsFileNames: [String]) {
        let sources = jsFileNames.map { (jsFileName) -> String in
            do {
                let jsFilePath = JavaScriptExecutor.getFullFilePath(fileName: jsFileName)
                let jsSource = try String(contentsOfFile: jsFilePath)
                return jsSource
            } catch {
                print(error)
                return ""
            }
        }
        setupJSSource(jsSource: sources.joined(separator: "\n"))
    }

    private func setupJSSource(jsSource: String) {
        registerExceptionHandler()
        jsContext?.evaluateScript(jsSource)
    }

    func registerExceptionHandler() {
        // Add an exception handler.
        jsContext?.exceptionHandler = { context, exception in
            if let exc = exception,
                let excStr = exc.toString() {
                print("JS Exception:\(excStr)")
                self.exception = excStr
            }
        }
    }

    func invokeMethod(method:String!, with params:[Any]!) -> JSValue! {
        let function = jsContext?.objectForKeyedSubscript(method)
        let result = function?.call(withArguments: params)
        return result
    }

    func generateError(from exception: String) -> Error {
       // TODO:
       return JSError()
    }

    func callMethodWithStringResult(method:String!, with params:[Any]!) -> Result<String, Error> {
        guard let result = invokeMethod(method: method, with: params) else {
            return .failure(JSError())
        }
        if !result.isUndefined {
            return .success(result.toString())
        }
        let error = generateError(from: exception)
        return .failure(error)
    }

    func callMethodWithNumberResult(method:String!, with params:[Any]!) -> Result<NSNumber, Error> {
        guard let result = invokeMethod(method: method, with: params) else {
            return .failure(JSError())
        }
        if !result.isUndefined {
            return .success(result.toNumber())
        }
        let error = generateError(from: exception)
        return .failure(error)
    }

    func callMethodWithIntResult(method:String!, with params:[Any]!) -> Result<Int32, Error> {
        guard let result = invokeMethod(method: method, with: params) else {
            return .failure(JSError())
        }
        if !result.isUndefined {
            return .success(result.toInt32())
        }
        let error = generateError(from: exception)
        return .failure(error)
    }

    func callMethodWithObjectResult(method:String!, with params:[Any]!) -> Result<Any, Error> {
        guard let result = invokeMethod(method: method, with: params) else {
            return .failure(JSError())
        }
        if !result.isUndefined {
            return .success(result.toObject() as Any)
        }
        let error = generateError(from: exception)
        return .failure(error)
    }

    func callMethodWithArrayResult(method:String!, with params:[Any]!) -> Result<[Any], Error> {
        guard let result = invokeMethod(method: method, with: params) else {
            return .failure(JSError())
        }
        if !result.isUndefined {
            return .success(result.toArray())
        }
        let error = generateError(from: exception)
        return .failure(error)
    }

    func callMethodWithDictionaryResult(method:String!, with params:[Any]!) -> Result<[String: Any], Error> {
        guard let result = invokeMethod(method: method, with: params) else {
          return .failure(JSError())
        }
        if !result.isUndefined {
            return .success(result.toDictionary() as? [String: Any] ?? [:])
        }
        let error = generateError(from: exception)
        return .failure(error)
    }
    
}

