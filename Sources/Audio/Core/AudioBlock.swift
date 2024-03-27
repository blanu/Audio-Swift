//
//  AudioBlock.swift
//
//
//  Created by Dr. Brandon Wiley on 3/26/24.
//

import Foundation

public class AudioBlock
{
    public let data: Data

    public convenience init()
    {
        self.init(Data(count: AudioStream.AUDIO_BLOCK_SAMPLES * AudioStream.AUDIO_BLOCK_SAMPLE_BYTES))
    }

    public init(_ data: Data)
    {
        self.data = data
    }

    public func mutableCopy() -> MutableAudioBlock
    {
        return MutableAudioBlock(self.data)
    }

    public func immutableCopy() -> AudioBlock
    {
        return AudioBlock(self.data)
    }
}

public class MutableAudioBlock
{
    public var data: Data

    public convenience init()
    {
        self.init(Data(count: AudioStream.AUDIO_BLOCK_SAMPLES * AudioStream.AUDIO_BLOCK_SAMPLE_BYTES))
    }

    public init(_ data: Data)
    {
        self.data = data
    }

    public func mutableCopy() -> MutableAudioBlock
    {
        return MutableAudioBlock(self.data)
    }

    public func immutableCopy() -> AudioBlock
    {
        return AudioBlock(self.data)
    }
}
