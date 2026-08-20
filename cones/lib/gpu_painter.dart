import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gpu/gpu.dart' as gpu;
import 'package:vector_math/vector_math.dart';

import 'cone_data.dart';
import 'shaders.dart';

gpu.RenderPipeline? _rpOutline;

class GpuPainter extends CustomPainter {
  GpuPainter(this.coneData);

  final ConeData coneData;

  @override
  void paint(Canvas canvas, Size size) {
    final colourTexture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
    );
    final depthTexture = gpu.gpuContext.createTexture(
      gpu.StorageMode.devicePrivate,
      size.width.toInt(),
      size.height.toInt(),
    );
    final renderTarget = gpu.RenderTarget.singleColor(
      gpu.ColorAttachment(
        texture: colourTexture,
        clearValue: Vector4(0.7, 0, 0, 1),
      ),
      depthStencilAttachment: gpu.DepthStencilAttachment(texture: depthTexture),
    );
    final commandBuffer = gpu.gpuContext.createCommandBuffer();
    final renderPass = commandBuffer.createRenderPass(renderTarget);

    final slOutline = outline;
    if (slOutline == null) {
      return;
    }
    if (_rpOutline == null) {
      final vert = slOutline['OutlineVertex']!;
      final frag = slOutline['OutlineFragment']!;
      _rpOutline = gpu.gpuContext.createRenderPipeline(vert, frag);
    }

    final verticesOutline = coneData.outlineF32l;
    final verticesDeviceBufferOutline = gpu.gpuContext
        .createDeviceBufferWithCopy(ByteData.sublistView(verticesOutline));
    renderPass.bindPipeline(_rpOutline!);
    renderPass.setPrimitiveType(gpu.PrimitiveType.line);

    final verticesViewOutline = gpu.BufferView(
      verticesDeviceBufferOutline,
      offsetInBytes: 0,
      lengthInBytes: verticesDeviceBufferOutline.sizeInBytes,
    );
    renderPass.bindVertexBuffer(verticesViewOutline);
    renderPass.draw(verticesOutline.length ~/ 3);

    commandBuffer.submit();
    final image = colourTexture.asImage();
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
