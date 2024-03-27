//
//  AudioConnection.swift
//
//
//  Created by Dr. Brandon Wiley on 3/26/24.
//

import Foundation

public class AudioConnection
{
    public let source: AudioStream
    public let sourceOutput: Int

    public let destination: AudioStream
    public let destinationInput: Int

    public init(source: AudioStream, sourceOutput: Int = 0, destination: AudioStream, destinationInput: Int = 0) throws
    {
        self.source = source
        self.sourceOutput = sourceOutput
        self.destination = destination
        self.destinationInput = destinationInput

        try self.connect()
    }

    public func updateAll()
    {
        self.destination.updateAll()
    }

    public func enqueue(_ block: AudioBlock, _ index: Int)
    {
        self.destination.enqueue(block, index)
    }

    func connect() throws
    {
        try self.source.add(destination: self, index: self.sourceOutput)
        self.source.activate()
        self.destination.activate()
    }
}

public enum AudioConnectionError: Error
{
    case badIndex(Int, Int) // actual, maximum
}
