import Metal
import simd

/// A convenient way to construct the vertices for a GUI quad.
struct GUIQuad {
  static var vertexPositions: [SIMD2<Float>] = [
    [0, 0],
    [1, 0],
    [1, 1],
    [0, 1]
  ]

  static var uvs: [SIMD2<Float>] = [
    [0, 0],
    [1, 0],
    [1, 1],
    [0, 1]
  ]

  var position: SIMD2<Float>
  var size: SIMD2<Float>
  var uvMin: SIMD2<Float>
  var uvSize: SIMD2<Float>
  var textureIndex: UInt16
  var tint: SIMD3<Float>

  init(
    position: SIMD2<Float>,
    size: SIMD2<Float>,
    uvMin: SIMD2<Float>,
    uvSize: SIMD2<Float>,
    textureIndex: UInt16,
    tint: SIMD3<Float> = [1, 1, 1]
  ) {
    self.position = position
    self.size = size
    self.uvMin = uvMin
    self.uvSize = uvSize
    self.textureIndex = textureIndex
    self.tint = tint
  }

  /// Creates a quad instance for the given sprite.
  init(
    for sprite: GUISpriteDescriptor,
    guiTexturePalette: GUITexturePalette,
    guiArrayTexture: MTLTexture,
    position: SIMD2<Int> = .zero
  ) {
    let textureSize: SIMD2<Float> = [
      Float(guiArrayTexture.width),
      Float(guiArrayTexture.height)
    ]

    self.position = SIMD2<Float>(position)
    size = SIMD2<Float>(sprite.size)
    uvMin = SIMD2<Float>(sprite.position) / textureSize
    uvSize = self.size / textureSize
    textureIndex = UInt16(guiTexturePalette.textureIndex(for: sprite.slice))
    tint = [1, 1, 1]
  }

  /// Creates a quad instance for the given character.
  init(
    for character: Character,
    with font: Font,
    fontArrayTexture: MTLTexture,
    tint: SIMD3<Float> = [1, 1, 1]
  ) throws {
    guard let descriptor = font.characters[character] else {
      throw GUIRendererError.invalidCharacter(character)
    }

    let arrayTextureWidth = Float(fontArrayTexture.width)
    let arrayTextureHeight = Float(fontArrayTexture.height)

    position = [
      0,
      Float(Font.defaultCharacterHeight - descriptor.height - descriptor.verticalOffset)
    ]
    size = [
      Float(descriptor.width),
      Float(descriptor.height)
    ]
    uvMin = [
      Float(descriptor.x) / arrayTextureWidth,
      Float(descriptor.y) / arrayTextureHeight
    ]
    uvSize = [
      Float(descriptor.width) / arrayTextureWidth,
      Float(descriptor.height) / arrayTextureHeight
    ]
    textureIndex = UInt16(descriptor.texture)
    self.tint = tint
  }

  func toVertices() -> [GUIVertex] {
    var vertices: [GUIVertex] = []
    vertices.reserveCapacity(4)
    for (position, uv) in zip(Self.vertexPositions, Self.uvs) {
      vertices.append(GUIVertex(
        position: position * size + self.position,
        uv: uv * uvSize + uvMin,
        tint: tint,
        textureIndex: textureIndex
      ))
    }
    return vertices
  }

  /// Translates the quad by the given amount.
  /// - Parameter amount: The amount of pixels to translate by along each axis.
  mutating func translate(amount: SIMD2<Float>) {
    self.position += amount
  }
}
