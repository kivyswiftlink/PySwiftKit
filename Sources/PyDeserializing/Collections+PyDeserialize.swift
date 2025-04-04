import Foundation
import PySwiftCore
import PythonCore
import PyTypes
//import PyComparable

extension RawRepresentable where RawValue: PyDeserialize {
    public init(object: PyPointer) throws {
        guard let raw = Self(rawValue: try RawValue(object: object)) else {
            throw PythonError.type("\(RawValue.self)")
        }
        self = raw
    }
}

extension Dictionary: PyDeserialize where Key: PyDeserialize,  Value: PyDeserialize {
    public init(object: PyPointer) throws {
        var d: [Key:Value] = .init()
        var pos: Int = 0
        var key: PyPointer?
        var value: PyPointer?
        while PyDict_Next(object, &pos, &key, &value) == 1 {
            guard let key, let value else { throw PythonError.index }
            d[try Key(object: key)] = try Value(object: value)
        }
        
        self = d
    }
    
    
}

extension Dictionary where Key == String, Value == PyPointer {
    public init(object: PyPointer) throws {
        var d: [Key:Value] = .init()
        var pos: Int = 0
        var key: PyPointer?
        var value: PyPointer?
        while PyDict_Next(object, &pos, &key, &value) == 1 {
            if let k = key {
                d[try String(object: k)] = value
            }
        }
        
        self = d
    }
    
    
}

fileprivate enum TestStruct: Int32 {
    case a
}

func test()  throws {
    let obj = PyPointer.None
    
    let dict: [Int:String] = try .init(object: obj)
    
    let teststruct = TestStruct.a
    try TestStruct.init(object: obj)
}
