//
//  Observable.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

public final class Observable<Value> {
    
    public var value: Value {
        didSet { notifyObservers() }
    }
    
    private struct ObserverWrapper<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }

    private var observers = [ObserverWrapper<Value>]()
    
    // Life cycle
    public init(_ value: Value) {
        self.value = value
    }
    
    // Public methods
    public func observe<T: AnyObject>(on observer: T, observerBlock: @escaping (T, Value) -> Void) {
        let block: (Value) -> Void = { [weak observer] value in
            guard let observer = observer else { return }
            observerBlock(observer, value)
        }
        let observerWrapper = ObserverWrapper(observer: observer, block: block)
        observers.append(observerWrapper)
        observerBlock(observer, value)
    }
    
    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    // Private help methods
    private func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async { observer.block(self.value) }
        }
    }
}
