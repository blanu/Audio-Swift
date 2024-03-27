//
//  RawFileOutput.swift
//
//
//  Created by Dr. Brandon Wiley on 3/26/24.
//

import Foundation

import SwiftHexTools

public class RawFileOutput: AudioStream
{
    let outputURL: URL
    let handle: FileHandle

    public init?(outputURL: URL)
    {
        self.outputURL = outputURL
        guard let handle = FileHandle(forWritingAtPath: self.outputURL.path) else
        {
            print("Bad file path: \(self.outputURL.path)")
            return nil
        }

        handle.seekToEndOfFile()

        self.handle = handle

        super.init(numInputs: 1)
    }

    public override func update()
    {
        self.process
        {
            inputs in

            for input in inputs
            {
                if let input
                {
                    print(input.data.hex)
                    handle.write(input.data)
                }
            }
        }
    }
}
