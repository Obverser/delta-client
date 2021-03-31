//
//  StopSoundPacket.swift
//  Minecraft
//
//  Created by Rohan van Klinken on 20/2/21.
//

import Foundation

struct StopSoundPacket: ClientboundPacket {
  static let id: Int = 0x52
  
  var flags: Int8
  var source: Int?
  var sound: Identifier?

  init(from packetReader: inout PacketReader) throws {
    flags = packetReader.readByte()
    if flags & 0x1 == 0x1 {
      source = packetReader.readVarInt()
    }
    if flags & 0x2 == 0x2 {
      sound = try packetReader.readIdentifier()
    }
  }
}