//
//  DSPInst.swift
//
//
//  Created by Dr. Brandon Wiley on 3/25/24.
//

import Foundation

public class DSPInst
{
    // computes limit((val >> rshift), 2**bits)
    //    static inline int32_t signed_saturate_rshift(int32_t val, int bits, int rshift)
    //    {
    //#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
    //        int32_t out;
    //        asm volatile("ssat %0, %1, %2, asr %3" : "=r" (out) : "I" (bits), "r" (val), "I" (rshift));
    //        return out;
    //        #elif defined(KINETISL)
    //        int32_t out, max;
    //        out = val >> rshift;
    //        max = 1 << (bits - 1);
    //        if (out >= 0) {
    //            if (out > max - 1) out = max - 1;
    //        } else {
    //            if (out < -max) out = -max;
    //        }
    //        return out;
    //#endif
    //    }
    static public func signed_saturate_rshift(_ val: Int32, _ bits: Int, _ rshift: Int) -> Int32
    {
        // computes limit((val >> rshift), 2**bits)

        var out: Int32
        var max: Int32

        out = val >> rshift

        max = 1 << (bits - 1)

        if out >= 0
        {
            if out > max - 1
            {
                out = max - 1
            }
        }
        else
        {
            if out < -max
            {
                out = -max;
            }
        }

        return out
    }

    // computes limit(val, 2**bits)
    //    static inline int16_t saturate16(int32_t val) __attribute__((always_inline, unused));
    //    static inline int16_t saturate16(int32_t val)
    //    {
    //#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
    //        int16_t out;
    //        int32_t tmp;
    //        asm volatile("ssat %0, %1, %2" : "=r" (tmp) : "I" (16), "r" (val) );
    //        out = (int16_t) (tmp);
    //        return out;
    //#else
    //        if (val > 32767) val = 32767;
    //        else if (val < -32768) val = -32768;
    //        return val;
    //#endif
    //    }

    static public func saturate16(val: Int32) -> Int16
    {
        // computes limit(val, 2**bits)
        var result = val

        if (result > 32767)
        {
            result = 32767;
        }
        else if (val < -32768)
        {
            result = -32768
        }

        return Int16(result)
    }

    //    // computes ((a[31:0] * b[15:0]) >> 16)
    //    static inline int32_t signed_multiply_32x16b(int32_t a, uint32_t b) __attribute__((always_inline, unused));
    //    static inline int32_t signed_multiply_32x16b(int32_t a, uint32_t b)
    //    {
    //#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
    //        int32_t out;
    //        asm volatile("smulwb %0, %1, %2" : "=r" (out) : "r" (a), "r" (b));
    //        return out;
    //        #elif defined(KINETISL)
    //        return ((int64_t)a * (int16_t)(b & 0xFFFF)) >> 16;
    //#endif
    //    }

    static public func signed_multiply_32x16b(_ a: Int32, _ b: UInt32) -> Int32
    {
        // computes ((a[31:0] * b[15:0]) >> 16)
        // return ((int64_t)a * (int16_t)(b & 0xFFFF)) >> 16;

        let int64a:   Int64 = Int64(a)

        let bint16:   Int16 = Int16(bitPattern: UInt16(b & 0x0000FFFF))
        let int64b:   Int64 = Int64(bint16)

        let axb:      Int64 = int64a * int64b
        let axbS16:   Int64 = axb >> 16

        let result:   Int32 = Int32(axbS16)

        return result
    }

    /*
     // computes ((a[31:0] * b[31:16]) >> 16)
     static inline int32_t signed_multiply_32x16t(int32_t a, uint32_t b) __attribute__((always_inline, unused));
     static inline int32_t signed_multiply_32x16t(int32_t a, uint32_t b)
     {
     #if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
     int32_t out;
     asm volatile("smulwt %0, %1, %2" : "=r" (out) : "r" (a), "r" (b));
     return out;
     #elif defined(KINETISL)
     return ((int64_t)a * (int16_t)(b >> 16)) >> 16;
     #endif
     }
     */
    static public func signed_multiply_32x16t(_ a: Int32, _ b: UInt32) -> Int32
    {
        // computes ((a[31:0] * b[31:16]) >> 16)
        //        return ((int64_t)a * (int16_t)(b >> 16)) >> 16;

        let int64a: Int64 = Int64(a)

        let bint16: Int16 = Int16(b)
        let bS16:   Int16 = bint16 >> 16
        let int64b: Int64 = Int64(bS16)

        let axb:    Int64 = int64a * int64b
        let axbS16: Int64 = axb >> 16

        let result: Int32 = Int32(axbS16)

        return result
    }

    //    // computes (((int64_t)a[31:0] * (int64_t)b[31:0]) >> 32)
    //    static inline int32_t multiply_32x32_rshift32(int32_t a, int32_t b) __attribute__((always_inline, unused));
    //    static inline int32_t multiply_32x32_rshift32(int32_t a, int32_t b)
    //    {
    //#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
    //        int32_t out;
    //        asm volatile("smmul %0, %1, %2" : "=r" (out) : "r" (a), "r" (b));
    //        return out;
    //        #elif defined(KINETISL)
    //        return ((int64_t)a * (int64_t)b) >> 32;
    //#endif
    //    }

    static public func multiply_32x32_rshift32(_ a: Int32, _ b: Int32) -> Int32
    {
        // computes (((int64_t)a[31:0] * (int64_t)b[31:0]) >> 32)
        // return ((int64_t)a * (int64_t)b) >> 32;

        let int64a: Int64 = Int64(a)
        let int64b: Int64 = Int64(b)

        let axb:    Int64 = int64a * int64b
        let axbS32: Int64 = axb >> 32

        let result: Int32 = Int32(axbS32)

        return result
    }

    //    // computes (((int64_t)a[31:0] * (int64_t)b[31:0] + 0x8000000) >> 32)
    //    static inline int32_t multiply_32x32_rshift32_rounded(int32_t a, int32_t b) __attribute__((always_inline, unused));
    //    static inline int32_t multiply_32x32_rshift32_rounded(int32_t a, int32_t b)
    //    {
    //#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
    //        int32_t out;
    //        asm volatile("smmulr %0, %1, %2" : "=r" (out) : "r" (a), "r" (b));
    //        return out;
    //        #elif defined(KINETISL)
    //        return (((int64_t)a * (int64_t)b) + 0x8000000) >> 32;
    //#endif
    //    }

    static public func multiply_32x32_rshift32_rounded(_ a: Int32, b: Int32) -> Int32
    {
        // computes (((int64_t)a[31:0] * (int64_t)b[31:0] + 0x8000000) >> 32)
        // return (((int64_t)a * (int64_t)b) + 0x8000000) >> 32;

        let int64a:  Int64 = Int64(a)
        let int64b:  Int64 = Int64(b)

        let axb:     Int64 = int64a * int64b
        let axb8:    Int64 = axb + 0x8000000
        let axb8S32: Int64 = axb8 >> 32

        let result:  Int32 = Int32(axb8S32)

        return result
    }

    //    // computes sum + (((int64_t)a[31:0] * (int64_t)b[31:0] + 0x8000000) >> 32)
    //    static inline int32_t multiply_accumulate_32x32_rshift32_rounded(int32_t sum, int32_t a, int32_t b) __attribute__((always_inline, unused));
    //    static inline int32_t multiply_accumulate_32x32_rshift32_rounded(int32_t sum, int32_t a, int32_t b)
    //    {
    //#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
    //        int32_t out;
    //        asm volatile("smmlar %0, %2, %3, %1" : "=r" (out) : "r" (sum), "r" (a), "r" (b));
    //        return out;
    //        #elif defined(KINETISL)
    //        return sum + ((((int64_t)a * (int64_t)b) + 0x8000000) >> 32);
    //#endif

    static public func multiply_accumulate_32x32_rshift32_rounded(_ sum: Int32, _ a: Int32, _ b: Int32) -> Int32
    {
        // computes sum + (((int64_t)a[31:0] * (int64_t)b[31:0] + 0x8000000) >> 32)
        // return sum + ((((int64_t)a * (int64_t)b) + 0x8000000) >> 32);

        let int64a:  Int64 = Int64(a)
        let int64b:  Int64 = Int64(b)

        let axb:     Int64 = int64a * int64b
        let axb8:    Int64 = axb + 0x8000000
        let axb8S32: Int64 = axb8 >> 32

        let result:  Int32 = sum + Int32(axb8S32)

        return result
    }

    //    // computes sum - (((int64_t)a[31:0] * (int64_t)b[31:0] + 0x8000000) >> 32)
    //    static inline int32_t multiply_subtract_32x32_rshift32_rounded(int32_t sum, int32_t a, int32_t b) __attribute__((always_inline, unused));
    //    static inline int32_t multiply_subtract_32x32_rshift32_rounded(int32_t sum, int32_t a, int32_t b)
    //    {
    //#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
    //        int32_t out;
    //        asm volatile("smmlsr %0, %2, %3, %1" : "=r" (out) : "r" (sum), "r" (a), "r" (b));
    //        return out;
    //        #elif defined(KINETISL)
    //        return sum - ((((int64_t)a * (int64_t)b) + 0x8000000) >> 32);
    //#endif
    //    }

    static public func multiply_subtract_32x32_rshift32_rounded(_ sum: Int32, _ a: Int32, _ b: Int32) -> Int32
    {
        // computes sum - (((int64_t)a[31:0] * (int64_t)b[31:0] + 0x8000000) >> 32)
        // return sum - ((((int64_t)a * (int64_t)b) + 0x8000000) >> 32);

        let int64a:  Int64 = Int64(a)
        let int64b:  Int64 = Int64(b)

        let axb:     Int64 = int64a * int64b
        let axb8:    Int64 = axb + 0x8000000
        let axb8S32: Int64 = axb8 >> 32

        let result:  Int32 = sum - Int32(axb8S32)

        return result
    }

//    // computes (a[31:16] | (b[31:16] >> 16))
//    static inline uint32_t pack_16t_16t(int32_t a, int32_t b) __attribute__((always_inline, unused));
//    static inline uint32_t pack_16t_16t(int32_t a, int32_t b)
//    {
//#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
//        int32_t out;
//        asm volatile("pkhtb %0, %1, %2, asr #16" : "=r" (out) : "r" (a), "r" (b));
//        return out;
//        #elif defined(KINETISL)
//        return (a & 0xFFFF0000) | ((uint32_t)b >> 16);
//#endif
//    }

    static public func pack_16t_16t(_ a: Int32, _ b: Int32) -> UInt32
    {
        // computes (a[31:16] | (b[31:16] >> 16))
        // return (a & 0xFFFF0000) | ((uint32_t)b >> 16);

        let uint32a: UInt32 = UInt32(a)
        let uint32b: UInt32 = UInt32(b)

        let aFF:     UInt32 = uint32a & 0xFFFF0000
        let bS16:    UInt32 = uint32b >> 16
        let result:  UInt32 = aFF | bS16

        return result
    }

//    // computes (a[31:16] | b[15:0])
//    static inline uint32_t pack_16t_16b(int32_t a, int32_t b) __attribute__((always_inline, unused));
//    static inline uint32_t pack_16t_16b(int32_t a, int32_t b)
//    {
//#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
//        int32_t out;
//        asm volatile("pkhtb %0, %1, %2" : "=r" (out) : "r" (a), "r" (b));
//        return out;
//        #elif defined(KINETISL)
//        return (a & 0xFFFF0000) | (b & 0x0000FFFF);
//#endif
//    }

    static public func pack_16t_16b(_ a: Int32, _ b: Int32) -> UInt32
    {
        // computes (a[31:16] | b[15:0])
        // return (a & 0xFFFF0000) | (b & 0x0000FFFF);

        let uint32a: UInt32 = UInt32(a)
        let uint32b: UInt32 = UInt32(b)

        let aF0:     UInt32 = uint32a & 0xFFFF0000
        let b0F:     UInt32 = uint32b & 0x0000FFFF
        let result:  UInt32 = aF0 | b0F

        return result
    }

//    // computes ((a[15:0] << 16) | b[15:0])
//    static inline uint32_t pack_16b_16b(int32_t a, int32_t b) __attribute__((always_inline, unused));
//    static inline uint32_t pack_16b_16b(int32_t a, int32_t b)
//    {
//#if defined (__ARM_ARCH_7EM__) || defined(KINETISK) || defined(__SAMD51__)
//        int32_t out;
//        asm volatile("pkhbt %0, %1, %2, lsl #16" : "=r" (out) : "r" (b), "r" (a));
//        return out;
//        #elif defined(KINETISL)
//        return (a << 16) | (b & 0x0000FFFF);
//#endif
//    }

    static public func pack_16b_16b(_ a: Int32, _ b: Int32) -> UInt32
    {
        // computes ((a[15:0] << 16) | b[15:0])
        // return (a << 16) | (b & 0x0000FFFF);

        let uint32a: UInt32 = UInt32(bitPattern: a)
        let uint32b: UInt32 = UInt32(bitPattern: b)

        let aS16:    UInt32 = uint32a << 16
        let b0F:     UInt32 = uint32b & 0x0000FFFF
        let result:  UInt32 = aS16 | b0F

        return result
    }

//    // computes ((a[15:0] * b[31:16])
//    static inline int32_t multiply_16bx16t(uint32_t a, uint32_t b) __attribute__((always_inline, unused));
//    static inline int32_t multiply_16bx16t(uint32_t a, uint32_t b)
//    {
//        int32_t out;
//        asm volatile("smulbt %0, %1, %2" : "=r" (out) : "r" (a), "r" (b));
//        return out;
//    }

    static public func multiply_16bx16t(_ a: UInt32, _ b: UInt32) -> UInt32
    {
        // computes ((a[15:0] * b[31:16])
        let axF0: UInt32 = a & 0xFFFF0000
        let bS16: UInt32 = b >> 16
        let result: UInt32 = axF0 * bS16
        return result
    }
}
