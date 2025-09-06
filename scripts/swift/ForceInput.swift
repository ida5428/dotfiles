import Foundation
import CoreAudio

// Replace this with the exact name of your preferred mic
let preferredInput = "MacBook Air Microphone"

// Helper: get the current input device name
func getCurrentInputName() -> String? {
    var defaultDeviceID = AudioDeviceID(0)
    var propertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDefaultInputDevice,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    var size = UInt32(MemoryLayout.size(ofValue: defaultDeviceID))
    let status = AudioObjectGetPropertyData(
        AudioObjectID(kAudioObjectSystemObject),
        &propertyAddress,
        0,
        nil,
        &size,
        &defaultDeviceID
    )
    guard status == noErr else { return nil }

    var name: CFString = "" as CFString
    size = UInt32(MemoryLayout<CFString>.size)
    let deviceID = defaultDeviceID
    var nameAddress = AudioObjectPropertyAddress(
        mSelector: kAudioObjectPropertyName,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )

    let nameStatus = withUnsafeMutablePointer(to: &name) {
        AudioObjectGetPropertyData(deviceID, &nameAddress, 0, nil, &size, $0)
    }
    guard nameStatus == noErr else { return nil }

    return name as String
}

// Helper: set the default input device by name
func setInputTo(_ target: String) {
    var devicesProp = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    var size: UInt32 = 0
    guard AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject),
                                         &devicesProp, 0, nil, &size) == noErr else {
        return
    }

    let count = Int(size) / MemoryLayout<AudioDeviceID>.size
    var deviceIDs = [AudioDeviceID](repeating: 0, count: count)
    guard AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                                     &devicesProp, 0, nil, &size, &deviceIDs) == noErr else {
        return
    }

    for id in deviceIDs {
        var name: CFString = "" as CFString
        var ns = UInt32(MemoryLayout<CFString>.size)
        var nameProp = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        let status = withUnsafeMutablePointer(to: &name) {
            AudioObjectGetPropertyData(id, &nameProp, 0, nil, &ns, $0)
        }
        if status == noErr {
            if (name as String) == target {
                var newID = id
                var defProp = AudioObjectPropertyAddress(
                    mSelector: kAudioHardwarePropertyDefaultInputDevice,
                    mScope: kAudioObjectPropertyScopeGlobal,
                    mElement: kAudioObjectPropertyElementMain
                )
                let sz = UInt32(MemoryLayout<AudioDeviceID>.size)
                AudioObjectSetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                                           &defProp, 0, nil, sz, &newID)
                return
            }
        }
    }
}

// Callback: fires when default input changes
func inputDeviceChanged(
    inObjectID: AudioObjectID,
    inNumberAddresses: UInt32,
    inAddresses: UnsafePointer<AudioObjectPropertyAddress>,
    inClientData: UnsafeMutableRawPointer?
) -> OSStatus {
    if let current = getCurrentInputName(), current != preferredInput {
        setInputTo(preferredInput)
    }
    return noErr
}

// Register listener
var addr = AudioObjectPropertyAddress(
    mSelector: kAudioHardwarePropertyDefaultInputDevice,
    mScope: kAudioObjectPropertyScopeGlobal,
    mElement: kAudioObjectPropertyElementMain
)

AudioObjectAddPropertyListener(
    AudioObjectID(kAudioObjectSystemObject),
    &addr,
    inputDeviceChanged,
    nil
)

// One-time check on startup
if let current = getCurrentInputName(), current != preferredInput {
    setInputTo(preferredInput)
}

RunLoop.current.run() // keep alive
