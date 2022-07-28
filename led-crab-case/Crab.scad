//
/*
Tjark Nieber
2022
mail@tjark-nieber.de
www.thingiverse.com/SharkNado

IT'S A CRAB!
Parametric case generator with slide lock for LED Crab-Game.

*/

// make exportable
render = true;

// SLT export
3D = false;

// Material thickness (mm). Tested with 3mm
th = 3;

// Join size
js = 2 * th;

// Cut correction (mm)
cor = 0.26;

// Outer width
width = 100 + 2 * th;

// Outer length
length = 44 + 2 * th;

// Outer height
height = 25 + 2 * th;

// Latch width
slot = 25; // latch width

// width of axis
axS = 2 * th;

extraH = th * 6;

frame = 0;

spacerHeight = height - 13 - 2 * th;

spacerPos = 8.6;

plexiWindow = [ 80, 9 ];
usbPos = spacerPos + th + 1;
usbPosX = 1.3;
tabPosX = 10;
tabPosY = length - th - 4 - 10;
plexiH = height - th * 3;

/* Calculations ************************************************************/

/* [Hidden] */
K = th;
$fn = 50;
open = 0;
cent = (width - slot) / 2;
Q = 0.001;
QQ = 2 * Q;
axD = norm([ th, axS ]);

if (render) {
  if (!3D) {
    render();
  } else {
    3D() render();
  }

} else {
  t(0, 0, height) rotate([ 180, 0, 0 ]) preview();
}

/* Rendering ************************************************************/

// rendered layout for cutting
module render() {
  t(-50, -50) {
    crabScissor();
    t(-th * 2 - 1) mirror([ 1, 0, 0 ]) crabScissor();
  }

  t(0, length, 0) mirror([ 0, 1, 0 ]) ground();
  t(0, -height - 1) front();
  t(0, length + 1) back();
  t(-1 - frame) mirror([ 1, 0, 0 ]) side();
  t(width + 1 + frame) side(cut = true);

  t(0, length + height + th) cover();
  t(width + slot, length + slot) latch();
  t(width + 3 * slot + 3 * th, length + slot) {
    latchPlate();
    t(-slot / 2 - 3 * th - 1, th) latchSide();
    t(slot / 2 + 2 * th + 1, th) latchSide();
  }
  t(0, -height - spacerHeight - 2 * th) spacer();
  t(0,length*2+height+2*th,0)plexi();
}

/* 3D Preview ************************************************************/

module preview() {
  3D() ground();
  color([ 1, 0, 1 ]) t(width, length - 3 * th, (height + 2 * th) / 2) r(180)
      r(90) 3D() crabScissor();
  color([ 1, 0, 1 ]) t(-2, length - 3 * th - 1, (height + 2 * th) / 2) r(180)
      r(90) mirror([ 1, 0, 0 ]) 3D() crabScissor();
  color([ 1, 0, 0 ]) t(0, th - 1) r(90) 3D() front();
  color([ 1, 0, 0 ]) t(0, length) r(90) 3D() back();
  color([ 0, 1, 0 ]) t(th - 1, 0) r(0, -90) 3D() side(cut = true);
  color([ 0, 1, 0 ]) t(width, 0) r(0, -90) 3D() side();
  t(0, length - K - 1.5 * th, height - th / 2) r(-open)
      t(0, -length + K + 1.5 * th, -th / 2) {
    % 3D() cover();
    t(width / 2, 0, -th) color([ 0, 0, 1 ]) 3D() latch();
    t(width / 2, th, -2 * th) color([ 0, 1, 0 ]) 3D() latchPlate();
    t((width - slot) / 2 - th, 2 * th, 0) color([ 1, 0, 0 ]) r(0, 90) 3D()
        latchSide();
    t((width - slot) / 2 + slot, 2 * th, 0) color([ 1, 0, 0 ]) r(0, 90) 3D()
        latchSide();
    color([ 1, 0, 0 ]) t(th, th + spacerPos, -spacerHeight) r(90, 0, 0) 3D()
        spacer();
    color([ 1, 0, 0 ]) mirror([ 0, 0, 1 ]) t(th + 1, usbPos, 0) usb();
    t(tabPosX + th, tabPosY, 0) color([ 0, 0, 1 ]) r(-90, 0, 90) 3D() tab();
    t(width - tabPosX, tabPosY, 0) color([ 0, 0, 1 ]) r(-90, 0, 90) 3D() tab();
  }
  %t(th,length-th,th)resize([0,4,0])r(90,0,0)3D()plexi();
}

/* Modules ************************************************************/

// Square for acrylic screen
module plexi() { square([ width - 2 * th, plexiH ]); }

// tabs for holding pcb in place
module tab(cut = false) {
  if (cut == false) {
    square([ 10, 10 ]);
    t(2.5, -th) pin(5, teeth = true);
  } else {
    t(2.5, -th) pin(5, teeth = false);
  }
}

// A lid to press pcb to the top
module spacer() {
  slotW = slot + 2 * th;
  difference() {
    square([ width - 2 * th, spacerHeight ]);
    t((width - 2 * th - slotW) / 2, spacerHeight - 2 * th)
        square([ slotW, 2 * th ]);
    for (i = [0:1:1])
      t(i * (width - 2 * th) / 1, 0) circle(d = (spacerHeight - th) * 2);
  }
  t(0, spacerHeight) teeth((width - 2 * th - slotW) / 2);
  t(width - 2 * th, spacerHeight) mirror([ 1, 0 ])
      teeth((width - 2 * th - slotW) / 2);
}

// the ground of the slide lock box. Actually the upper side of the crab
module ground() {
  difference() {
    t(th, th) square([ width - 2 * th, length - 2 * th ]);
    t(width, th + 1) mirror([ 1, 0 ]) cutOuts();
  }
  teeth(width);
  t(0, length - th) teeth(width);
  t(th) r(0, 0, 90) teeth(length);
  t(width) r(0, 0, 90) teeth(length);
}

// Usb pcb preview and it's cutting holes
module usb(cut = false) {
  if (cut) {
    t(0, (15 - 9) / 2, 0) {
      t(9, 0) circle(d = 3);
      t(9, 9) circle(d = 3);
    }
  } else {

    difference() {
      cube([ 15, 15, 1.5 ]);
      t(9, 2.5, -1) cylinder(d = 3, h = 3);
      t(9, 12.5, -1) cylinder(d = 3, h = 3);
    }

    t(-1, (15 - 7.8) / 2) cube([ 5.5, 7.8, 4 ]);
  }
}

// The cute mouth
module mouth() {
  difference() {
    circle(d = 5);
    t(0, -1) circle(d = 5);
  }
}

// Front of slide box. Actually the back of the crab
module front() {
  difference() {
    union() {
      t(th) square([ width - 2 * th, height - th ]);
      t(cent - 1.5 * th, height - th) hull() {
        square([ slot + 3 * th, 0.1 ]);
        t(th / 2) square([ slot + 2 * th, th ]);
      }
    }
    t(cent, height - 2 * th) square([ slot, th ]);
    teeth(width, false);
  }
  t(th) r(0, 0, 90) teeth(height + th);
  t(width) r(0, 0, 90) teeth(height + th);
}

// Backside of the slide box. Actually the cute front face of the crab
module back() {
  difference() {
    t(th) square([ width - 2 * th, height ]);
    t(width / 2, height / 2 + 3) mouth();
    t(30, height / 2) circle(d = height - 5 * th);
    t(width - 30, height / 2) circle(d = height - 5 * th);
    teeth(width, false);
  }
  t(th) r(0, 0, 90) teeth(height);
  t(width) r(0, 0, 90) teeth(height);
}

// Crab side with cute legs
module side(cut = false) {
  difference() {

    union() {
      *hull() {
        t(-frame, -frame, 0) square([ height + frame, length + 2 * frame ]);
        t(height, th) square([ th, length - 2 * th ]);
        t(height, length - 2 * th - (axS - th) / 2 - K - cor / 2)
            square([ th + extraH, axD ]);
      }
      t(-frame, -frame, 0) square([ height + frame, length + 2 * frame ]);
      t(height, 0, 0) resize([ extraH + th, length ]) mirror([ 1, 0, 0 ])
          r(0, 0, 90) import("crab_leg.svg");
    }
    t((height + 2 * th) / 2 - 10, length - 3 * th) scissorTeeth(teeth = false);
    t(height - 0.5 * th, length - 1.5 * th - K) circle(d = axD);
    t(th) r(0, 0, 90) teeth(length, false);
    teeth(height + th, false);
    t(0, length - th) teeth(height, false);
    if (cut)
      t(height - th - 2, usbPos + 7.5) resize([ 8, 13 ]) hull() {
        t(0, -3) circle(d = 3);
        t(0, 3) circle(d = 3);
      }
  }
}

// The top side of the slide lock box. Actually the bottom side of the crab
module cover() {
  slotW = slot + 2 * th;
  lipW = (width - (slot - 6 * th)) / 4;
  difference() {
    union() {
      t(th) square([ width - 2 * th, length - th - 0.1 * th ]);
      *t(lipW / 2 + th) resize([ lipW, 1.5 * th ]) circle(d = width);
      *t(width - (lipW / 2 + th)) resize([ lipW, 1.5 * th ]) circle(d = width);
    }
    t(cent - 1.5 * th, -th) square([ slot + 3 * th, 2 * th ]);
    t(width / 2, slot / 2 + 2 * th) {
      hull() {
        circle(d = slot - 2 * th);
        t(0, th) circle(d = slot - 2 * th);
      }
      t(-slot / 2, -(slot - 2 * th) / 2 + (slot - th) / 4) r(0, 0, 90)
          pin((slot - th) / 2, false);
      t(slot / 2 + th, -(slot - 2 * th) / 2 + (slot - th) / 4) r(0, 0, 90)
          pin((slot - th) / 2, false);
    }
    t(th, spacerPos) teeth((width - 2 * th - slotW) / 2, teeth = false);
    t(width - th, spacerPos) mirror([ 1, 0 ])
        teeth((width - 2 * th - slotW) / 2, teeth = false);
    t(th + usbPosX, usbPos, 0) usb(cut = true);
  }
  t(0, length - 2 * th - (axS - th) / 2 - K - cor / 2)
      square([ th, axS + cor ]);
  t(width - th, length - 2 * th - (axS - th) / 2 - K - cor / 2)
      square([ th, axS + cor ]);
}

// Cutouts for rotary knobs
module cutOuts() {
  a = (width - 96.52) / 2;

  t(a, 0) {
    // square([96.52,25.4]);
    t(10.66, 3.64) circle(d = 3.5);
    t(10.16, 17.87) circle(d = 6.5);
    t(35.56, 17.87) circle(d = 6.5);
    t(60.96, 17.87) circle(d = 6.5);
    t(86.36, 17.87) circle(d = 6.5);
  }
}

// crab scissor
module crabScissor() {
  scale(1.349) import("crab_scissor.svg");
  t(0, 0, 0) r(0, 0, 90) scissorTeeth(teeth = true);
}

// Pressfitting teeth for crab scissor
module scissorTeeth(teeth = true) { teeth(10, teeth, margin = th); }

/* Slidelock ************************************************************/

module latch() {
  difference() {
    t(-slot / 2) hull() {
      t(0, th) square([ slot, 3 * th + slot - th ]);
      t(th / 2) square([ slot - th, 3 * th + slot ]);
    }
    t(0, slot / 2 + 2 * th) circle(d = slot - 2.5 * th);
  }
  t(-slot / 2 - th, 2 * th + slot) square([ slot + 2 * th, th ]);
  t(-slot / 2 - th, th) square([ slot + 2 * th, th ]);
}

module latchPlate() {
  L = slot + th;
  D = (slot - th) / 2;
  t(-slot / 2 - th) difference() {
    t(0, th) square([ slot + 2 * th, L ]);
    t(th, (L - D) / 2 + th) r(0, 0, 90) pin(D, false);
    t(slot + 2 * th, (L - D) / 2 + th) r(0, 0, 90) pin(D, false);
  }
}

module latchSide() {
  L = slot - th;
  D = (slot - th) / 2;
  t(0, th) square([ th + 0.15, L ]);
  t(0, (L - D) / 2 + th) r(0, 0, 90) pin(D);
  t(2 * th + 0.15, (L - D) / 2 + th) r(0, 0, 90) pin(D);
}

/* Teeth logic ************************************************************/

module teeth(distance, teeth = true, margin) {
  margin = (margin != undef) ? margin : 5 * th;
  dist = distance - margin;
  N = floor(dist / (js));
  n = N + (N + 1) % 2;
  JS = dist / n;
  cOffset = margin / 2;

  for (n = [0:1:n]) {
    if (n % 2 == 0)
      translate([ JS * n + cOffset, 0, 0 ]) pin(JS, teeth);
  }
}

module pin(JS, teeth = true) {
  if (teeth) {
    translate([ -cor / 2, -Q ]) square([ JS + cor, th + QQ ]);
  } else {
    translate([ cor / 2, -Q ]) square([ JS - cor, th + QQ ]);
  }
}

/* Helper wrapper for translates ************************************************************/

module t(x = 0, y = 0, z = 0) { translate([ x, y, z ]) children(); }
module r(x = 0, y = 0, z = 0) { rotate([ x, y, z ]) children(); }
module 3D() { linear_extrude(height = th) children(); }
