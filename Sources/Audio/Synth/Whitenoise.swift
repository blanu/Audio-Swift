//
//  Whitenoise.swift
//
//
//  Created by Dr. Brandon Wiley on 3/25/24.
//

import Foundation

import Datable

// Ported from Teensy Audio Library to Swift.
// Park-Miller-Carta Pseudo-Random Number Generator
// http://www.firstpr.com.au/dsp/rand31/
//
// Note: this effect starts muted, set an amplitude > 0 to turn it on.
public class Whitenoise: AudioStream
{
    static public var instances: UInt32 = 0

    public var seed: UInt32

    public var level: Int32 // 0=off, 65536=max

    public init()
    {
        self.seed = 1 + Whitenoise.instances
        Whitenoise.instances += 1

        self.level = 0

        super.init(numOutputs: 1)
    }

    public func amplitude(n: Float)
    {
        var n2: Float = n
        if n2 < 0.0
        {
            n2 = 0.0
        }
        else if n2 > 1.0
        {
            n2 = 1.0
        }

        self.level = Int32(UInt32(n2 * 65536.0))
    }

    public override func update()
    {
        var p: Int = 0
        var end: Int = 0
        var n1: Int32 = 0
        var n2: Int32 = 0
        var gain: Int32 = 0
        var lo: UInt32 = 0
        var hi: UInt32 = 0

        let block = self.allocate().mutableCopy()

        gain = level
        guard gain != 0 else
        {
            return
        }

        p = block.data.startIndex
        end = block.data.index(0, offsetBy: block.data.count)
        lo = seed

        while p < end
        {
            var val1: UInt32
            var val2: UInt32

//          hi = multiply_16bx16t(16807, lo); // 16807 * (lo >> 16)
            hi = DSPInst.multiply_16bx16t(16807, lo) // 16807 * (lo >> 16)

//          lo = 16807 * (lo & 0xFFFF);
            lo = 16807 * (lo & 0xFFFF)

//          lo = 16807 * (lo & 0xFFFF)
            lo = 16807 * (lo & 0xFFFF)

//          lo += (hi & 0x7FFF) << 16;
            lo += (hi & 0x7FFF) << 16

//          lo += hi >> 15;
            lo += hi >> 15

//          lo = (lo & 0x7FFFFFFF) + (lo >> 31);
            lo = (lo & 0x7FFFFFFF) + (lo >> 31)

//          n1 = signed_multiply_32x16b(gain, lo);
            n1 = DSPInst.signed_multiply_32x16b(gain, lo)

//          hi = multiply_16bx16t(16807, lo); // 16807 * (lo >> 16)
            hi = DSPInst.multiply_16bx16t(16807, lo)  // 16807 * (lo >> 16)

//          lo = 16807 * (lo & 0xFFFF);
            lo = 16807 * (lo & 0xFFFF)

//           lo += (hi & 0x7FFF) << 16;
            lo += (hi & 0x7FFF) << 16

//          lo += hi >> 15;
            lo += hi >> 15

//          lo = (lo & 0x7FFFFFFF) + (lo >> 31);
            lo = (lo & 0x7FFFFFFF) + (lo >> 31)

//          n2 = signed_multiply_32x16b(gain, lo);
            n2 = DSPInst.signed_multiply_32x16b(gain, lo)

//          val1 = pack_16b_16b(n2, n1);
            val1 = DSPInst.pack_16b_16b(n2, n1)

//          hi = multiply_16bx16t(16807, lo); // 16807 * (lo >> 16)
            hi = DSPInst.multiply_16bx16t(16807, lo)  // 16807 * (lo >> 16)

//          lo = 16807 * (lo & 0xFFFF);
            lo = 16807 * (lo & 0xFFFF)

//          lo += (hi & 0x7FFF) << 16;
            lo += (hi & 0x7FFF) << 16

//          lo += hi >> 15;
            lo += hi >> 15

//          lo = (lo & 0x7FFFFFFF) + (lo >> 31);
            lo = (lo & 0x7FFFFFFF) + (lo >> 31)

//          n1 = signed_multiply_32x16b(gain, lo);
            n1 = DSPInst.signed_multiply_32x16b(gain, lo)

//          hi = multiply_16bx16t(16807, lo); // 16807 * (lo >> 16)
            hi = DSPInst.multiply_16bx16t(16807, lo)  // 16807 * (lo >> 16)

//          lo = 16807 * (lo & 0xFFFF);
            lo = 16807 * (lo & 0xFFFF)

//          lo += (hi & 0x7FFF) << 16;
            lo += (hi & 0x7FFF) << 16

//          lo += hi >> 15;
            lo += hi >> 15

//          lo = (lo & 0x7FFFFFFF) + (lo >> 31);
            lo = (lo & 0x7FFFFFFF) + (lo >> 31)

//          n2 = signed_multiply_32x16b(gain, lo);
            n2 = DSPInst.signed_multiply_32x16b(gain, lo)

//          val2 = pack_16b_16b(n2, n1);
            val2 = DSPInst.pack_16b_16b(n2, n1)

//            *p++ = val1;
//            *p++ = val1;
            let val1Data = val1.data
            block.data[p] = val1Data[0]
            p += 1
            block.data[p] = val1Data[1]
            p += 1
            block.data[p] = val1Data[2]
            p += 1
            block.data[p] = val1Data[3]
            p += 1

//            *p++ = val2;
//            *p++ = val2;
            let val2Data = val2.data
            block.data[p] = val2Data[0]
            p += 1
            block.data[p] = val2Data[1]
            p += 1
            block.data[p] = val2Data[2]
            p += 1
            block.data[p] = val2Data[3]
            p += 1
        }

        seed = lo

        transmit(block.immutableCopy(), 0)
    }
}
