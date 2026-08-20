in vec3 position;

void main() {
  gl_Position = vec4(position.xy, position.z, 1);
  // gl_Position = vec4(position.xy, position.z * 0.5 + 0.5, 1);
}

