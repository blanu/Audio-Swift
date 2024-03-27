import XCTest
@testable import Audio

final class AudioTests: XCTestCase
{
    func testWhitenoise() throws
    {
        let synth = Whitenoise()
        synth.amplitude(n: 1.0)

        guard let output = RawFileOutput(outputURL: URL(fileURLWithPath: "/Users/dr.brandonwiley/whitenoise.raw")) else
        {
            XCTFail()
            return
        }

        let _ = try AudioConnection(source: synth, destination: output)

        for _ in 0..<(44100/(AudioStream.AUDIO_BLOCK_SAMPLES * AudioStream.AUDIO_BLOCK_SAMPLE_BYTES))
        {
            AudioStream.update()
        }
    }
}
