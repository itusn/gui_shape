import 'dart:typed_data';
import 'package:flutter/material.dart';

/// The [GuiBitmapBuffer] class provides an interface for creating custom 24-bit or 32-bit bitmaps and flutter image
class GuiBitmapBuffer {

  /// The structure of a Bitmap Buffer is defined below:
  /// Reference Documentation: https://en.wikipedia.org/wiki/BMP_file_format
  /// bitmap file header : (14 bytes)
  /// WORD    bfType;               // [0-1] 'B' 'M'
  /// DWORD   bfSize;               // [2-5] Size of File (headers + data) - little endian
  /// WORD    bfReserved1;          // [6-7] 0 , 0
  /// WORD    bfReserved2;          // [8-9] 0 , 0
  /// DWORD   bfOffBits;            // [10-13] 54
  /// bitmap info header : (40 bytes)
  /// DWORD      biSize;            // [14-17] 40
  /// LONG       biWidth;           // [18-21] width of image
  /// LONG       biHeight;          // [22-25] height of image
  /// WORD       biPlanes;          // [26-27] # of planes = 1
  /// WORD       biBitCount;        // [28-29] # of bits per pixel
  /// DWORD      biCompression;     // [30-33]
  /// DWORD      biSizeImage;       // [34-37] size of bitmap image (# of pixels * bytes per pixel)
  /// LONG       biXPelsPerMeter;   // [38-41] the horizontal resolution of the image. (pixel per metre, signed integer) (200 dpi = 7874)
  /// LONG       biYPelsPerMeter;   // [42-45] the vertical resolution of the image. (pixel per metre, signed integer) (200 dpi = 7874)
  /// DWORD      biClrUsed;         // [46-49] the number of colors in the color palette, or 0 to default to 2n
  /// DWORD      biClrImportant;    // [50-53] the number of important colors used, or 0 when every color is important; generally ignored
  /// bitmap data : (size of bitmap image)
  /// BYTE  bdData                  // [...]
  /// data for image is ordered from bottom of image to top of image.
  ///   Row N
  ///   Row N-1
  ///     ...
  ///     ...
  ///   Row 2
  ///   Row 1

  /// Width of bitmap image in pixels
  final int width;

  /// Height of bitmap image in pixels
  final int height;

  /// Number of bits per pixel (ie. 24 for 24-bit RGB pixel, 32 for for ARGB pixel w/ transparency)
  final int bitsPerPixel;

  /// # of bytes required to render a pixel (informational only)
  int get bytesPerPixel => _bytesPerPixel;

  // data bits : ( width * height * bytes per pixel )
  late Uint8List _imageData;
  late int _bytesPerPixel;
  late int _bytesPerRow;

  /// Starting offset of Bitmap header
  int get headerOffset => 0;
  /// Starting offset of Bitmap data
  int get imageOffset => 54;
  /// Starting offset of Bitmap image for row [row] (zero-based)
  int imageRowOffset(int row) {
    // row: base 0
    return 54 + ((height - row - 1) * _bytesPerRow);
  }

  /// Constant for 32-bit pixel w/ ARGB value
  static const int bitsPerPixelArgb = 32;
  /// Constant for 24-bit pixel w/ RGB value
  static const int bitsPerPixelRgb = 24;

  /// Raw bitmap data
  Uint8List get imageData => _imageData;

  /// Create a bitmap buffer with header prepopulated with necessary data.  The actual image data
  /// must still be populated by the user.
  GuiBitmapBuffer({required this.width, required this.height, this.bitsPerPixel = bitsPerPixelArgb}) {
    _prepareHeader();
  }

  void _prepareHeader() {
    _bytesPerPixel = (bitsPerPixel+7) ~/ 8; // # of bytes per pixel
    _bytesPerRow = ((bitsPerPixel * width) / 32).ceil() * 4;
    int imgsize = (_bytesPerRow * height);
    int bmpsize = imgsize + 54;
    // bitmap header
    _imageData = Uint8List(bmpsize);
    _imageData[0] = 0x42; // B
    _imageData[1] = 0x4d; // M
    _imageData[2] = bmpsize & 0xff;
    _imageData[3] = (bmpsize >> 8) & 0xff;
    _imageData[4] = (bmpsize >> 16) & 0xff;
    _imageData[5] = (bmpsize >> 24) & 0xff;
    _imageData[10] = 0x36; // size of bitmap header + info header
    // bitmap info
    _imageData[14] = 0x28; // size of info header
    _imageData[18] = width & 0xff;
    _imageData[19] = (width >> 8) & 0xff;
    _imageData[20] = (width >> 16) & 0xff;
    _imageData[21] = (width >> 24) & 0xff;
    _imageData[22] = height & 0xff;
    _imageData[23] = (height >> 8) & 0xff;
    _imageData[24] = (height >> 16) & 0xff;
    _imageData[25] = (height >> 24) & 0xff;
    _imageData[26] = 0x01; // 1 plane
    _imageData[28] = bitsPerPixel; // ie. 32-bits for pixel (ie. ARGB)
    _imageData[34] = imgsize & 0xff;
    _imageData[35] = (imgsize >> 8) & 0xff;
    _imageData[36] = (imgsize >> 16) & 0xff;
    _imageData[37] = (imgsize >> 24) & 0xff;
    // 200 DPI : x-DPI and y-DPI
    _imageData[38] = 0xc2;
    _imageData[39] = 0x1e;
    _imageData[42] = 0xc2;
    _imageData[43] = 0x1e;
  }

  /// Convert Bitmap buffer into a Flutter [Image] widget.
  Image toImage() {
    return Image.memory(_imageData);
  }

}