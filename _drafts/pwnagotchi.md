---
layout: post  
title: "Tamagotchi for Hackers!"  
tags: [cybersecurity, microsoft, exchange, outlook, incident-response]  
thumbnail: /assets/images/pwnagotchi.jpg
---

If you grew up in the late 90's or the early 2000's then you probably remember Tamagotchis. The little handheld digital pet from Bandai was a huge hit, you took care of the little creature by feeding it, playing games etc using 3 small buttons.

![Tamagotchi](/assets/images/pwnagotchi/tamagotchi.jpeg)

To my delight I stumbled across a fantastic open source project called Pwnagotchi, a nod to Tamagotchis but with a focus on cybersecurity and hacking.
This cute little device is a DIY build with multiple options for the components, though generally the brains of the operation are handled by a raspberry pi.
After some research I settled on a battery powered version with a 2.13inch E-Ink Display (like Amazon Kindles Screen) powered by a Raspberry Pi Zero 2W.

As I have recently taken an interest in building electronics paired with my knowledge of cyber security this was the perfect project for me to undertake.
Thankfully, the Pwnagotchi build is very beginner friendly, only some basic linux and raspberry pi knowledge is required to get it up and running.

Here is a list of the parts I used:
- Raspberry Pi Zero 2 W with Header Pins
- Waveshare v4 2.13inch E-Ink Display Hat
- PiSugar 3 1200mAh Battery
- 32GB MicroSD Card
- Micro USB to USB-A cable
- 3D Printed Case

The case is not entirely necessary but as I already own a FDM 3D printer it was a no-brainer.

INSERT LINK TO 3D PRINT

Here is a link to the Pwnagotchi website and wiki with documentation and ideas for your build.
https://pwnagotchi.ai/
https://pwnagotchi.org/getting-started/index.html






IMPORTANT
- Turn off Deauthentication before booting, otherwise your poor neighbours and anyone else around you will have a horrible time being kicked off their wifi networks. (Not to mention the legality issues with deauthentication packets)
- Change the SSH password for the device
- Change the Web GUI password
- Change the bettercap Password


