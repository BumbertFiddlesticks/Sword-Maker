// This shader is modified from here:
// https://www.shadertoy.com/view/slBXWc

// DANGER: 
// SPAGHETTI CODE, READ AT YOUR OWN RISK

// IMPORTANT: 
// color values are offset offline but not in HTML5 version
// ctrl + f "hacky" and uncomment out the last two "hacky solutions" if you want
// correct colors for offline version, comment out for online version

// ^^ tried doing this with a uniform bool but that just broke things more...

shader_type canvas_item;
render_mode blend_disabled;

uniform int frame = 0;

// handle, gem interior outline color
uniform int index1 = 3;
// gem interior color
uniform int index2 = 0;
// gem blade shape
uniform int index3 = 2;

uniform vec2 dimHandle = vec2(40, 40);
uniform vec2 dimGem = vec2(20, 60);

uniform float seed = 0.;
uniform float seed2 = 0.;

// exterior color of blade (colored outline)
vec3 lightMap(float v) {
  vec3 arr[30] = vec3[] ( 
  // blue
  vec3(255),vec3(203,219,252),vec3(95,205,228), vec3(99,155,255), vec3(91,110,225),
  // gold 
  vec3(255),vec3(251,242,54), vec3(255,182,45), vec3(223,113,38), vec3(172,50,50),
  // green
  vec3(255),vec3(203,219,252),vec3(153,229,80), vec3(106,190,48), vec3(55,148,110),
  // brown 
  vec3(255),vec3(238,195,154),vec3(217,160,102),vec3(180,123,80), vec3(143,86,59),
  // grey
  vec3(255),vec3(203,219,252),vec3(155,173,183),vec3(132,126,135),vec3(105,106,106),
  // pink
  vec3(255),vec3(238,195,154),vec3(215,123,186),vec3(217,87,99),  vec3(118,66,138)
  );
  return arr[ 5 * index1 + min(4, int(v)) ] / 255.; 
}

// interior color of blade
vec3 darkMap(float v) {
  vec3 arr[45] = vec3[] (   
  // blue 
  vec3(95,205,228), vec3(99,155,255), vec3(91,110,225), vec3(48,96,130), vec3(63,63,116),
  // red 
  vec3(238,195,154),vec3(215,123,186),vec3(217,87,99),  vec3(172,50,50), vec3(69,40,60),
  // green 
  vec3(153,229,80), vec3(106,190,48), vec3(55,148,110), vec3(48,96,130), vec3(63,63,116),
  // brown
  vec3(217,160,102),vec3(180,123,80), vec3(143,86.,59), vec3(102,57,49), vec3(69,40,60),
  // grey
  vec3(155,173,183),vec3(132,126,135),vec3(105,106,106),vec3(89,86,82),  vec3(50,60,57),
  // pink
  vec3(215,123,186),vec3(217,87,99),  vec3(118,66,138), vec3(63,63,116), vec3(50,60,57),
  // purple-gold
  vec3(251,242,54), vec3(255,182,45), vec3(217,87,99),  vec3(118,66,138),vec3(63,63,116),
  // red-gold
  vec3(251,242,54), vec3(255,182,45), vec3(223,113,38), vec3(172,50,50), vec3(69,40,60),
  // muddy brown
  vec3(153,229,80), vec3(143,151,74), vec3(138,111,48), vec3(75,105,47), vec3(82,75,36)
  ); 
  if (index2 < 9)
    return arr[ 5 * index2 + min(4, int(v)) ] / 255.; 
  else
    return arr[ 5 * index2 - 45 + 4 - min(4, int(v)) ] / 255.;
}

// color of handle
vec3 handleMap(float v) {
  vec3 arr[36] = vec3[] (
  // blue
  vec3(63,63,116),vec3(48,96,130), vec3(91,110,225), vec3(95,205,228), vec3(203,219,252),vec3(255),
  // red-gold
  vec3(69,40,60), vec3(172,50,50), vec3(223,113,38), vec3(255,182,45), vec3(251,242,54), vec3(255),
  // green
  vec3(63,63,116),vec3(48,96,130), vec3(55,148,110), vec3(106,190,48), vec3(153,229,80), vec3(203,219,252),
  // brown
  vec3(69,40,60), vec3(102,57,49), vec3(143,86,59),  vec3(180,123,80), vec3(217,160,102),vec3(238,195,154),
  // grey
  vec3(50,60,57), vec3(118,66,138),vec3(105,106,106),vec3(155,173,183),vec3(203,219,252),vec3(255),
  // pink
  vec3(50,60,57), vec3(63,63,116), vec3(118,66,138), vec3(217,87,99),  vec3(215,123,186),vec3(238,195,154)
  ); 
  return arr[ 6 * index1 + min(5, int(5. * v)) ] / 255.;
}

// probably need either hash or rand, not both
highp float rand(vec2 co) {
  co += 10. * seed;
  highp float a = 12.9898;
  highp float b = 78.233;
  highp float c = 43758.5453;
  highp float dt= dot(co.xy ,vec2(a,b));
  highp float sn= mod(dt,3.14159);
  return fract(sin(sn) * c);
}

// stolen from iq
vec2 hash(vec2 v) {
  v = vec2( dot(v,vec2(127.1,311.7)), dot(v,vec2(269.5,183.3)) );
  return -1.0 + 2.0*fract(sin(v)*43758.5453123);
}

float noise(in vec2 v) {
  const float K1 = 0.366025404; // (sqrt(3)-1)/2;
  const float K2 = 0.211324865; // (3-sqrt(3))/6;

  vec2  i = floor( v + (v.x+v.y)*K1 );
  vec2  a = v - i + (i.x+i.y)*K2;
  float m = step(a.y,a.x); 
  vec2  o = vec2(m,1.0-m);
  vec2  b = a - o + K2;
  vec2  c = a - 1.0 + 2.0*K2;
  vec3  h = max( 0.5-vec3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
  vec3  n = h*h*h*h*vec3( dot(a,hash(i+0.0)), dot(b,hash(i+o)), dot(c,hash(i+1.0)));
  return dot( n, vec3(70.0) );
}

float hexTop(vec2 frag) {
    if (index3 == 0) // pointy
      return abs(frag.x) + abs(frag.y);
    if (index3 == 1) // right diag / 
      return abs(frag.x - (0.5 * dimGem.x) + 2.) + abs(frag.y);
    if (index3 == 2) // left diag
      return abs(frag.x + (0.5 * dimGem.x) - 2.) + abs(frag.y);
    if (index3 == 3) // square
      return frag.x; 
    if (index3 == 4) // square -> diag
      return frag.x + frag.y;
    if (index3 == 5) // diag -> square
      return -frag.x + frag.y;       
}

float hexagon(vec2 frag, vec2 dim) {
  // extend height because we cropped the bottom outline
  dim.y += 1.;

  // rectangle shape
  float d = max((dim.y / dim.x) * abs(frag.x), abs(frag.y));

  // (modified) diamond shape
  float d2 = (frag.y > 0.) ? hexTop(frag) : abs(frag.x) + abs(frag.y);
 
  // intersect both shapes
  return step(d, 0.5 * dim.y) * step(d2, 0.5 * dim.y);
}

// forms ---_-_ shape to color with
float stepHole(float v, float h) {
  return step(h,v ) + (step(h, v + 2.) - step(h, v + 1.));
}

// choose length of each ---_-_ segment, depending on gem height 
float chooseN() {
    float h = dimGem.y;
    if (h <= 14.)
        return 2.;
    if (h <= 21.)
        return 3.;
    if (h <= 28.)
        return 4.;
    return 5.;
}

float getMirroredNoise(vec2 mir, vec2 frag) {
  float f = 0.0;
  mir += 40. * seed2;
  mir *= 0.01;
  mat2 m = mat2(vec2(1.6,  -1.2), vec2(1.2,  1.6));
  f =  0.5000 * noise(mir); mir = m * mir;
  f += 0.2500 * noise(mir); mir = m * mir;
  f += 0.1250 * noise(mir); mir = m * mir;
  f += 0.0625 * noise(mir); mir = m * mir;

  f = 0.5 + 0.5 * f;

  float v = 0.5 * (1. - cos(3.14159 * 100. * f));   // *50.
  //v = (4. * v + 2.) / 6.; // <-- makes it more symmetrical (but less colors on both sides)
  // = 16. * v * v * (1.-v) * (1.-v);
  //v = 4. * v * (1.-v);
  v = min(1., v * (0.6 + 0.9 * frag.y / dimHandle.y));
  v = (frag.x <= 0.5 * max(dimHandle.x, dimGem.x)) ? max(0., v - 2. / 6.) : v;
  
  return v;
}

float CA(in sampler2D tex, vec2 uv, vec2 pixel_size) {
  float modifier;
  float count = 0.;
  
  for (float x = -1.; x < 2.; x++) {
    for (float y = -1.; y < 2.; y++) {
      modifier = min(1., abs(x) + abs(y)) * (1.5 - 0.5 * abs(x * y));
      count += texture(tex, uv + vec2(x, y) * pixel_size).x * modifier;
    }
  }

  float e = texture(tex, uv).x;
  if (e == 1. && count < 4.5)
    e = 0.;
  else if (e == 0. && count > 6.)
    e = 1.;
  return e;
}

float sumNeighbours(in sampler2D tex, vec2 uv, vec2 pixel_size) {
  vec2 s = pixel_size;
  return texture(tex, uv - vec2(s.x, 0.)).x + texture(tex, uv + vec2(s.x, 0.)).x
       + texture(tex, uv - vec2(0., s.y)).x + texture(tex, uv + vec2(0., s.y)).x;
}

float prodNeighbours(in sampler2D tex, vec2 uv, vec2 pixel_size) {
  return (texture(tex, uv - vec2(pixel_size.x, 0.)).x + texture(tex, uv + vec2(pixel_size.x, 0.)).x)
       * (texture(tex, uv - vec2(0., pixel_size.y)).x + texture(tex, uv + vec2(0., pixel_size.y)).x);
}

bool hasWhiteNeighbour(in sampler2D tex, vec2 uv, vec2 pixel_size) {   
    return (sumNeighbours(tex, uv, pixel_size) > 0.);
}

bool isInteriorCorner(float e, in sampler2D tex, vec2 uv, vec2 pixel_size) {
    return e == 0.5 && prodNeighbours(tex, uv, pixel_size) >= 2.25;     
}

bool isExteriorCorner(float e, in sampler2D tex, vec2 uv, vec2 pixel_size) {
    return e == 0.5 && sumNeighbours(tex, uv, pixel_size) == 1.;
}

bool isBlackOutlined(float e, in sampler2D tex, vec2 uv, vec2 pixel_size) {
    return e == 0. && sumNeighbours(tex, uv, pixel_size) == 2.;
}

bool wasInDiagCorner(float e, in sampler2D tex, vec2 uv, vec2 pixel_size) {
    // this shouldn't work but somehow it does
    return e == 1. && prodNeighbours(tex, uv, pixel_size) < 2.; 
}

bool isIsolated(in sampler2D tex, vec2 uv, vec2 pixel_size) {
    return sumNeighbours(tex, uv, pixel_size) == 0.;
}

void fragment() {
  vec2 uv = SCREEN_UV;
  vec2 sz = SCREEN_PIXEL_SIZE;
  vec2 dim = 1. / sz;
  vec2 frag = FRAGCOORD.xy;

  // should probably remove this
  vec2 centre = 0.5 * vec2(max(dimHandle.x, dimGem.x), dimHandle.y + dimGem.y);

  float e = texture(TEXTURE, uv).x;
  vec2 mir = vec2(abs(centre.x - frag.x), frag.y);

  if (frag.y < dimHandle.y) {
    if (frame == 0) {   
      float rand = rand(mir);
  
      if (frag.y > dimHandle.y - 4.) // >= ?
        e = step(0.4, rand);
      else if (frag.y > 6. && frag.y < 12.)
        e = 0.;
      else
        e = step(0.5, rand);
  
      e = max(e ,step(mir.x, 1.));
      e *= step(1. + max(0., floor(0.5 * (dimGem.x - dimHandle.x))), frag.x) * step(1., frag.y) *
           step(frag.x, max(dimHandle.x, floor(0.5 * (dimGem.x + dimHandle.x))) - 1.) * step(frag.y, dimHandle.y - 1.);
    }
    else if (frame < 5) {
      e = CA(TEXTURE, uv, sz);
    }
    else if (frame < 6 && frag.y > dimHandle.y - 8. && frag.y < dimHandle.y - 4.) {
      float rand = rand(mir);
      e = max(e, step(0.1, rand));
      e *= step(1. + max(0., floor(0.5 * (dimGem.x - dimHandle.x))), frag.x) * step(1., frag.y) *
           step(frag.x, max(dimHandle.x, floor(0.5 * (dimGem.x + dimHandle.x))) - 1.) * step(frag.y, dimHandle.y - 1.);
    }
    else if (frame < 10) {
      e = CA(TEXTURE, uv, sz);  
    }
    else if (frame < 11) {
      e = max(e, step(mir.x, 1.)) * step(1., frag.y);
    } 
    else if (frame < 12) {
      e = (e == 0. && hasWhiteNeighbour(TEXTURE, uv, sz)) ? .5 : e;
    }
    else if (frame < 17) {
      e = (isInteriorCorner(e, TEXTURE, uv, sz) || isBlackOutlined(e, TEXTURE, uv, sz)) ? 1. : e;
    }
    else if (frame < 18) {
      e = isExteriorCorner(e, TEXTURE, uv, sz) ? 0. : e; 
    }
    else if (frame < 19) {
      e = wasInDiagCorner(e, TEXTURE, uv, sz) ? 0.5 : e;  
    }
    else if (frame < 20) {
      e = isExteriorCorner(e, TEXTURE, uv, sz) ? 0. : e;
    }
    else if (frame < 21) {
      e = isIsolated(TEXTURE, uv, sz) ? 0. : e;  
    }
    else if (frame < 22) {
    float k = clamp(getMirroredNoise(mir, frag), 0., 1.);

    // hacky solution: index1 == 2 bugs otherwise (I DONT KNOW WHY)
    if (frag.y > dimHandle.y - 1. && mir.x < 1.)
      e = 1.;    

    if (e > 0.5)
      COLOR = vec4(handleMap(k), 1.);
    else if (e == 0.5)
      COLOR = vec4(34, 32, 52, 255) / 255.;
    else 
      COLOR = vec4(0.,0.,0.,0.);
    }
    
    // hacky solution: colors are offset for some reason
    COLOR.rgb += vec3(1. / 255.);

    if (frame < 21) {
      COLOR = vec4(e, e, e, 1.);     
    }   
  }

  if (frag.y > dimHandle.y) { 
    vec2 q = frag - vec2(centre.x, dimHandle.y + 0.5 * (dimGem.y - 1.));

    vec3 col = vec3(hexagon(q, dimGem) - 0.5 * hexagon(q,dimGem - 2.),
                    hexagon(q, dimGem - 2.) - hexagon(q,dimGem - 4.),
                    hexagon(q, dimGem - 4.));
    
	vec2 shade = vec2(1.);
	float n = chooseN();
	// max(0., dimHandle.x - dimGem.x) maybe
	vec2 fragShift = frag - vec2(0., dimHandle.y);
    for (float i = 1.; i < n; i++) { 
        shade = max(shade, 
                   1. + (n-i) * stepHole(ceil(dimGem.y / n) * i, fragShift.y)
                       - step(centre.x, frag.x));                  
    }
    
	// this doesnt seem correct
	/*
    if (frag.y > dimHandle.y + dimGem.y - 2.)
        shade = vec2(1.);
    else if (frag.y > dimHandle.y + dimGem.y - 4.)
        shade = vec2(2. - step(0.5 * max(dimGem.x, dimHandle.x), frag.x));
   */
   
    col.bg *= shade;
  
    if (col.r == 1.)
      COLOR = vec4(34, 32, 52, 255) / 255.;
    else if (col.r == 0.)
      COLOR = vec4(0.);
    else if (col.g > 0.)
      COLOR = vec4(lightMap(col.g - 1.), 1.); 
    else if (col.b > 0.)
      COLOR = vec4(darkMap(col.b - 1.), 1.); 

    // hacky solution: colors are offset for some reason
    if (col.r > 0.) 
      COLOR.rgb += vec3(1. / 255.);
  }
  
  COLOR.a = clamp(COLOR.a, 0., 1.);
}
