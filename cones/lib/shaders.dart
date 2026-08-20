import 'package:flutter_gpu/gpu.dart' as gpu;

const String _outlineShaderBundlePath = 'build/shaderbundles/outline.shaderbundle';

gpu.ShaderLibrary? _outlineShaderLibrary;

gpu.ShaderLibrary? get outline {
  if (_outlineShaderLibrary != null) {
    return _outlineShaderLibrary;
  }
  gpu.ShaderLibrary.fromAsset(_outlineShaderBundlePath)
      .then((sl) => _outlineShaderLibrary = sl);
  return null;
}
