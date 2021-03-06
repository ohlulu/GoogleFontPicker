//
//  Bindable.swift
//  GoogleFontPicker
//
//  Created by Ohlulu on 2021/3/1.
//

import Foundation

public final class Bindable<Value> {
    
    public var value: Value {
        didSet { notifyBinders() }
    }
    
    private struct Binder<Value> {
        weak var target: AnyObject?
        let block: (Value) -> Void
    }

    private var binders = [Binder<Value>]()
    
    // Life cycle
    public init(_ value: Value) {
        self.value = value
    }
    
    // Public methods
    public func bind<T: AnyObject>(on target: T, binderBlock: @escaping (T, Value) -> Void) {
        let block: (Value) -> Void = { [weak target] value in
            guard let target = target else { return }
            binderBlock(target, value)
        }
        let binder = Binder(target: target, block: block)
        binders.append(binder)
        binderBlock(target, value)
    }
    
    public func remove(target: AnyObject) {
        binders = binders.filter { $0.target !== target }
    }
    
    // Private help methods
    private func notifyBinders() {
        for binder in binders {
            DispatchQueue.main.async { binder.block(self.value) }
        }
    }
}
