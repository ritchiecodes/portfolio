---
layout: post
title: "Building a 3D Printed RGB Stage for Figurines"
tags: [3d printing, electronics, diy, rgb]
thumbnail: /assets/images/rgb-stage/banner.webp
---

I've been looking for a way to display some of my figurine collection that's a bit more interesting than just putting them on a shelf. A proper display stage with lighting felt like the right answer — and since I have a 3D printer, making one from scratch was an obvious choice.

The goal: a compact 3D printed stage that can sit on a desk or shelf, with RGB LEDs wired inside and controlled by a small remote. No soldering to a microcontroller, no code — just a clean, self-contained display piece.

<br>

## Design

The stage was designed with a few things in mind:

* A flat platform large enough to hold one or two figurines
* Hollow walls and a recessed base to route LED strips through
* Diffused lighting panels so the LEDs blend rather than produce harsh hotspots
* A small channel at the rear to run the power cable out cleanly

I modelled the stage in [your CAD tool], printed in [filament colour/material]. The hollow interior keeps print time reasonable while giving plenty of room for the LED strips and wiring.

<figure>
  <img src="/assets/images/rgb-stage/design.webp" alt="Stage design render" width="500">
  <figcaption>Stage design</figcaption>
</figure>

<br>

## Components

* 3D printed stage body
* RGB LED strip (5V, with remote receiver)
* 44-key IR remote and receiver
* 5V USB power supply
* USB cable (for power input)
* Diffuser panel (cut from white acrylic or thick white PETG)

The LED strip I used comes as a kit with the IR receiver and remote already paired — no additional wiring to a separate controller needed. Power goes in through USB, which keeps it clean and easy to run from a USB port on a monitor or desk hub.

<br>

## Printing

[add print settings — layer height, infill, supports, etc.]

The trickiest part of the print was the diffuser channel along the front face. I printed this section slowly to keep the walls consistent, as any variation shows up clearly when the LEDs are lit.

<figure>
  <img src="/assets/images/rgb-stage/print.webp" alt="Stage fresh off the printer" width="500">
  <figcaption>Fresh off the printer</figcaption>
</figure>

<br>

## Assembly

1. Cut the LED strip to length to fit the interior perimeter of the stage
2. Route the strip around the inner walls, sticking it in place with the adhesive backing
3. Feed the wiring through the rear channel to the IR receiver
4. Slot the diffuser panel into the front face opening
5. Run the USB cable out through the rear cutout

The whole assembly takes about 20 minutes once the print is done. No soldering required — the LED strip connectors are plug-and-play.

<figure>
  <img src="/assets/images/rgb-stage/assembly.webp" alt="LED strip installed inside stage" width="500">
  <figcaption>LED strip fitted inside the stage</figcaption>
</figure>

<br>

## Result

The remote gives full control over colour, brightness, and a handful of effects including fade, flash, and strobe. For a static display I tend to leave it on a single colour that complements the figurine, but the colour-cycle modes look great for photos.

<figure>
  <img src="/assets/images/rgb-stage/finished.webp" alt="Completed RGB stage with figurine" width="600">
  <figcaption>Completed stage</figcaption>
</figure>

<br>

## Final Thoughts

This was a fun weekend project that sits at the intersection of 3D printing and basic electronics — no programming or specialist skills required. If you have a printer and a collection of figures gathering dust on a shelf, a display stage like this is an easy way to give them a proper home.

The design files are available [link to files].
