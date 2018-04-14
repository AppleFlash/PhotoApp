//
//  AsyncOperation.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 15.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    
    enum OperationState: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    private let stateQueue = DispatchQueue(label: "com.photo.operation.state", attributes: .concurrent)
    private var rawState: OperationState = .ready
    
    var state: OperationState {
        get {
            return stateQueue.sync { rawState }
        }
        set {
            willChangeValue(forKey: newValue.keyPath)
            stateQueue.sync(flags: .barrier) { rawState = newValue }
            didChangeValue(forKey: newValue.keyPath)
        }
    }
    
}

extension AsyncOperation {
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
    
    override func cancel() {
        super.cancel()
        
        state = .finished
    }
    
}
