import Foundation

public struct CreativeInventoryActionPacket: ServerboundPacket {
  public static let id: Int = 0x27

  public var slot: Int16
  public var clickedItem: Slot

  public func writePayload(to writer: inout PacketWriter) {
    writer.writeShort(slot)
    writer.writeSlot(clickedItem)
  }
}
