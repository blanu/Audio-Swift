//
//  AudioStream.swift
//
//
//  Created by Dr. Brandon Wiley on 3/22/24.
//

import Foundation

public class AudioStream
{
    static public let AUDIO_BLOCK_SAMPLES = 128
    static public let AUDIO_BLOCK_SAMPLE_BYTES = 2
    static public let AUDIO_SAMPLE_RATE_EXACT = 44100.0
    static public let AUDIO_SAMPLE_RATE = 44100.0
    static public let noAUDIO_DEBUG_CLASS = false

    static var first: AudioStream? = nil

    static public func setFirst(_ stream: AudioStream?)
    {
        self.first = stream
    }

    static public func getFirst() -> AudioStream?
    {
        return self.first
    }

    static public func update()
    {
        if let first
        {
            first.updateAll()
        }
    }

    public let numInputs: Int
    public let numOutputs: Int

    var active: Bool = false
    var outputs: [[AudioConnection]] // Many connections for each output channel, reduces the need for splitters.
    var inputQueue: [AudioBlock?]

    public init(numInputs: Int = 0, numOutputs: Int = 0, inputQueue: [AudioBlock] = [])
    {
        self.numInputs = numInputs
        self.numOutputs = numOutputs
        self.inputQueue = inputQueue

        if self.inputQueue.isEmpty
        {
            self.inputQueue = [AudioBlock?](repeating: nil, count: numInputs)
        }

        self.outputs = [[AudioConnection]](repeating: [], count: numOutputs)

        let oldFirst = AudioStream.getFirst()
        if oldFirst == nil
        {
            AudioStream.setFirst(self)
        }
    }

    public func updateAll()
    {
        if self.active
        {
            self.update()
        }

        for destination in self.outputs
        {
            for connection in destination
            {
                connection.updateAll()
            }
        }
    }

    // Override update() in subclasses
    public func update()
    {
    }

    // Allocate 1 audio data block.
    public func allocate() -> AudioBlock
    {
        return AudioBlock()
    }

    public func transmit(_ block: AudioBlock, _ index: Int)
    {
        for destination in outputs
        {
            for connection in destination
            {
                connection.enqueue(block, index)
            }
        }
    }

    public func enqueue(_ block: AudioBlock, _ index: Int)
    {
        self.inputQueue[index] = block
    }

    public func add(destination: AudioConnection, index: Int) throws
    {
        guard index >= 0 else
        {
            throw AudioConnectionError.badIndex(index, self.numInputs)
        }

        guard index < self.numOutputs else
        {
            throw AudioConnectionError.badIndex(index, self.numInputs)
        }

        self.outputs[index].append(destination)
    }

    public func activate()
    {
        self.active = true
    }

    public func deactivate()
    {
        self.active = false
    }

    func process(_ function: ([AudioBlock?]) -> ())
    {
        var inputs: [AudioBlock?] = []
        for index in 0..<self.numInputs
        {
            let result = self.dequeue(index)
            inputs.append(result)
        }

        function(inputs)
    }

    func dequeue(_ index: Int) -> AudioBlock?
    {
        let result = self.inputQueue[index]

        self.inputQueue[index] = nil

        return result
    }
}
