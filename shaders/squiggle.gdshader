shader_type canvas_item;

// Adjust in the Inspector to control your hand-drawn style
uniform int frame_rate : hint_range(1, 24) = 8;        // Traditional animation speed (8-12 fps)
uniform float amplitude : hint_range(0.0, 15.0) = 4.0;  // How far lines jump
uniform float wave_size : hint_range(1.0, 100.0) = 40.0; // Scale of the line wiggle
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest; // Godot 4 texture

// Pseudo-random number generator
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D Noise used to deform the lines
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

void fragment() {
    // Step 1: Snap TIME to mimic choppy frame-by-frame drawing
    float stepped_time = floor(TIME * float(frame_rate));
    
    // Step 2: Scale UVs to calculate the noise distortion vector
    vec2 noise_uv = SCREEN_UV * wave_size;
    
    // Step 3: Shift the noise field using the stepped time frames
    float offset_x = noise(noise_uv + vec2(stepped_time * 13.51, stepped_time * 4.23));
    float offset_y = noise(noise_uv + vec2(stepped_time * -7.89, stepped_time * 19.41));
    
    // Combine offsets and scale by amplitude relative to screen resolution
    vec2 displacement = (vec2(offset_x, offset_y) - 0.5) * (amplitude / 1000.0);
    
    // Step 4: Add a tiny global screen jitter per-frame to simulate manual scanner misalignment
    vec2 scanner_jitter = vec2(hash(vec2(stepped_time, 1.0)), hash(vec2(stepped_time, 2.0))) - 0.5;
    displacement += scanner_jitter * 0.001; // Keep it very subtle
    
    // Final output: Sample the screen using the hand-drawn distortion
    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + displacement);
}
