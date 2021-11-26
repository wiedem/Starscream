//
//  MockTransport.swift
//  Starscream
//
//  Created by Dalton Cherry on 1/28/19.
//  Copyright © 2019 Vluxe. All rights reserved.
//

@testable import Starscream
import Foundation

public class MockTransport: Transport {
    public var usingTLS: Bool {
        false
    }

    private weak var delegate: TransportEventClient?

    private let id: String
    weak var server: MockServer?
    var uuid: String {
        id
    }

    public init(server: MockServer) {
        self.server = server
        id = UUID().uuidString
    }

    public func register(delegate: TransportEventClient) {
        self.delegate = delegate
    }

    public func connect(url _: URL, timeout _: Double, certificatePinning _: CertificatePinning?) {
        server?.connect(transport: self)
        delegate?.connectionChanged(state: .connected)
    }

    public func disconnect() {
        server?.disconnect(uuid: uuid)
    }

    public func write(data: Data, completion _: @escaping ((Error?) -> Void)) {
        server?.write(data: data, uuid: uuid)
    }

    public func received(data: Data) {
        delegate?.connectionChanged(state: .receive(data))
    }

    public func getSecurityData() -> (SecTrust?, String?) {
        return (nil, nil)
    }
}

public class MockSecurity: CertificatePinning, HeaderValidator {
    public func evaluateTrust(trust _: SecTrust, domain _: String?, completion: (PinningState) -> Void) {
        completion(.success)
    }

    public func validate(headers _: [String: String], key _: String) -> Error? {
        nil
    }
}
