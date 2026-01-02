---
layout: post  
title: "Tamagotchi for Hackers!"  
tags: [cybersecurity, microsoft, exchange, outlook, incident-response]  
thumbnail: /assets/images/pwnagotchi/tamagotchi.jpeg
---

If you grew up in the late 90's or the early 2000's then you probably remember Tamagotchis. The little handheld digital pet from Bandai was a huge hit, you took care of the little creature by feeding it, playing games etc using 3 small buttons.

<figure>
  <img 
    src="/assets/images/pwnagotchi/tamagotchi.jpeg"
    alt="Bandai Tamagotchi"
    width="250">
  <figcaption>Bandai Tamagotchi</figcaption>
</figure>

To my delight I stumbled across a fantastic open source project called Pwnagotchi, a nod to Tamagotchis but with a focus on cybersecurity and hacking.
This cute little device is a DIY build with multiple options for the components, though generally the brains of the operation are handled by a raspberry pi.
After some research I settled on a battery powered version with a 2.13inch E-Ink Display (like Amazon Kindles Screen) powered by a Raspberry Pi Zero 2W.

As I have recently taken an interest in building electronics paired with my knowledge of cyber security this was the perfect project for me to undertake.
Thankfully, the Pwnagotchi build is very beginner friendly, only some basic linux and raspberry pi knowledge is required to get it up and running.

Here is a list of the parts I used:
- Raspberry Pi Zero 2 W with Header Pins
- Waveshare v4 2.13inch E-Ink Display Hat
- PiSugar 3 1200mAh Battery
- 32GB MicroSD Card (and a USB adaptor or card reader to connect it to your PC)
- Micro USB to USB-A cable
- [3D Case I Printed](https://cults3d.com/en/3d-model/gadget/coque-pwnagotchi-waveshare3-pisugar3-et-protection-d-ecran-plexiglass)

The case is not entirely necessary but as I already own a FDM 3D printer it was a no-brainer.

<figure>
  <img 
    src="/assets/images/pwnagotchi/parts.jfif"
    alt="Pwnagotchi Parts"
    width="600">
  <figcaption>Pwnagotchi Parts</figcaption>
</figure>

Instead of going over the installation steps, I will provide the guide I used for anyone that would like to tackle this project themselves: [Guide I Used](https://pwnagotchi.org/getting-started/index.html)

There is also some good information here as well:
[Pwnagotchi Website](https://pwnagotchi.ai/)

The build process was actually quite straightforward, and being a solderless build is a bonus for anyone yet to venture into soldering.

The Waveshare screen clicks into the pins on the raspberry pi and the PiSugar battery connects via the back of the raspberry pi using 4 mounting screws.


<figure>
  <div class="side-by-side">
    <img 
      src="/assets/images/pwnagotchi/waveshare.jfif"
      alt="Waveshare Screen">
    <img 
      src="/assets/images/pwnagotchi/pwnagotchi-side.jfif"
      alt="Side view of Pwnagotchi">
  </div>
  <figcaption>Pwnagotchi Build</figcaption>
</figure>

After putting the device together I proceeded with the installation of the Pwnagotchi software. This is done by flashing a custom image from the [guide](https://pwnagotchi.org/getting-started/index.html) to the micro sd card via the Raspberry Pi Imager software.

After the imaging process, it was time to insert the sdcard into our newly build Pwnagotchi and connect it to the computer.

The guide is thorough enough to show the process for Windows, Linux and MacOS but since I already had my Windows laptop in front of me as I followed the guide, I decided to continue the process with it.

To get the Pwnagotchi to be recognised as a USB Ethernet device in Windows I was required to install the RNDIS driver, the setup was simple and the PC detected the pwnagotchi as a network device.

I assigned a static IP to the ethernet device as per the [guide](https://pwnagotchi.org/getting-started/index.html) so it would be easy to ssh into and access the web gui.

I recommend changing the SSH password as the first thing you do after logging into it. From a security standpoint, using a default password to login to any device is always a big no.

Configuring the device was simple using the provided wizard which can be accessed using `sudo pwnagotchi --wizard`

After going through the prompts and completing the configuration your Pwnagotchi is technically ready to start capturing wifi handshakes but there are still some important configurations I would setup first.

Now, you can edit the configuration file manually, it is located on the device at `/etc/pwnagotchi/config.toml` but there is a simpler more user friendly way to edit this config with the web gui.

You can access the web gui of the pwnagotchi by having it connected to the PC and navigating in a browser to the IP address on port 8080. for eg. `http://10.0.0.2:8080`. (If this doesn't work, continue reading the recommended settings in the next section.)
If successful, you will see your cute little Pwnagotchi face inside your web browser now. Next, I clicked on Plugins and enabled the webcfg plugin.
Now I can edit all the settings via the web gui instead of needing to ssh into the device each time I want to make a change.

Here is a list of option I recommend setting:
```toml
# Opt Out of PwnGrid reporting (Opt Out of sharing data publicly, used for leaderboards etc)
main.plugins.grid.enabled = false
main.plugins.grid.report = false

# Turn off sending deauthentication packets (so your neighbours dont hate you.)
personality.deauth = false

# Changing the web gui password (and enabling the web gui if it hasn't been enabled already)
ui.web.enabled = true
ui.web.auth = true
ui.web.username = "USERNAME"
ui.web.password = "PASSWORD"
```

Pwangotchi runs bettercap under the hood to handle packet capturing. bettercap in itself is a very powerful and capable piece of software which can be accessed via a web gui just like the pwnagotchi screen can. Try `pwnagotchi.local` in your web browser (replace pwnagotchi with the name you gave your device) to access bettercap. (The default credentials are `pwnagotchi` for the username and password.)

I recommend changing the bettercap password from the default as well, this is a little trickier to change but I will explain the steps I took:

1. SSH into your Pwnagotchi
2. Go to `/usr/local/share/bettercap/caplets/pwnagotchi-auto.cap`
3. Edit these options: 
```
set api.rest.username "ENTER USERNAME"
set api.rest.password "ENTER PASSWORD"
```
4. Go to `/etc/pwnagotchi/config.toml`
5. Edit these options:
```
bettercap.username = "USERNAME"
bettercap.password = "PASSWORD"
```

6. Restart your Pwnagotchi with `sudo reboot`

Now when you head to the bettercap web gui you should be able to use your new credentials.

Please Note: These credentials are stored in plain text so don't use a password that would be dangerous if compromised (Like your banking password.)

<figure>
  <img 
    src="/assets/images/pwnagotchi/pwnagotchi.jfif"
    alt="Completed Pwnagotchi"
    width="600">
  <figcaption>Completed Pwnagotchi</figcaption>
</figure>

After the reboot, I unplugged my Pwnagotchi and tested it on my home network.
It captured the handhshake succesfully. This will be indicated on the screen, you can head [here](https://pwnagotchi.ai/usage/) for more information on the Pwnagotchi GUI.

Now the Pwnagotchi merely captures wifi hanshakes, they still require more work and software to crack the password. You can access the capture files by connecting your Pwnagotchi to your PC, sshing into the device and going to `/home/pi/handshakes`
Thankfully, my wifi password was too strong to crack but alas, the Pwnagotchi has done its job.












IMPORTANT
- Turn off Deauthentication before booting, otherwise your poor neighbours and anyone else around you will have a horrible time being kicked off their wifi networks. (Not to mention the legality issues with deauthentication packets)
- Change the SSH password for the device
- Change the Web GUI password
- Change the bettercap Password


