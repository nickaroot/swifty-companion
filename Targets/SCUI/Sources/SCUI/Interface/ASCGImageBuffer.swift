//
//  ASCGImageBuffer.swift
//
//
//  Created by Nikita Arutyunov on 23.12.2021.
//

import AsyncDisplayKit
import Foundation

public class ASCGImageBuffer: NSObject {
    var createdData: Bool = false
    var isVM: Bool
    var length: UInt
    var mutableBytes: UnsafeMutableRawPointer

    public init(
        length: UInt
    ) {
        self.length = length
        self.isVM = false  // length >= vm_page_size

        guard isVM else {
            mutableBytes = malloc(Int(length))

            super.init()

            return
        }

        mutableBytes = mmap(
            UnsafeMutableRawPointer?.none,
            Int(length),
            PROT_WRITE | PROT_READ,
            MAP_ANONYMOUS | MAP_PRIVATE,
            (VM_MEMORY_COREGRAPHICS_DATA) << 24,
            0
        )

        guard mutableBytes != MAP_FAILED else {
            isVM = false

            super.init()

            return
        }

        super.init()
    }

    deinit {
        if !createdData {
            Self.deallocateBuffer(buf: mutableBytes, length: length, isVM: isVM)
        }
    }

    public func createDataProviderAndInvalidate() -> CGDataProvider? {
        createdData = true

        if isVM {
            let result = vm_protect(
                mach_task_self_,
                mutableBytes.load(as: vm_address_t.self),
                length,
                1,
                VM_PROT_READ
            )

            assert(result == noErr, "Error marking buffer as read-only: %@")
        }

        let d = NSData(bytesNoCopy: mutableBytes, length: Int(length)) { [isVM] bytes, length in
            Self.deallocateBuffer(buf: bytes, length: UInt(length), isVM: isVM)
        }

        return CGDataProvider(data: d)
    }

    static func deallocateBuffer(buf: UnsafeMutableRawPointer, length: UInt, isVM: Bool) {
        if isVM {
            let result = vm_deallocate(mach_task_self_, buf.load(as: vm_address_t.self), length)

            assert(result == noErr, "Failed to unmap cg image buffer: %@")
        } else {
            free(buf)
        }
    }
}
