+++
date = '2024-12-26T13:21:35+01:00'
draft = true
title = 'Test123'
+++

From: Stefan Hagen <sh+openbsd-tech@codevoid.de>
To: tech@openbsd.org, mglocker@openbsd.org
Cc: 
Bcc: 
Subject: Re: sys/uvideo: forward error bit to consumer
Reply-To: 
In-Reply-To: <878qsb8f0h.wl-kirill@korins.ky>
Precedence: first-class
Priority: normal
X-Editor: Vim 9.1
X-Operating-System: OpenBSD 7.6 amd64
X-Mailer: Mutt 2.2.13 (2024-03-09)
X-PGP-Fingerprint: CBD3 C468 64B4 6517 E8FB B90F B6BC 2EC5 52BE 43BA
OpenPGP: id=52BE43BA; url=https://codevoid.de/0/gpg; preference=signencrypt

Kirill A. Korinsky wrote (2024-12-19 23:49 CET):
> tech@,
> 
> Some invalid frames or frames with an error flag from the camera might be 
> essential for a stream consumer for synchronization and other purposes. 
> Without this, the consumer may be unable to synchronize the stream or play 
> it at all.
> 
> Instead of skipping frames that the driver considers incorrect, this change 
> forwards them to the V4L consumer with the V4L2_BUF_FLAG_ERROR flag set, 
> allowing the consumer to decide whether to skip the frame or use parts of it.
> 
> This change fixes the embedded webcam on the ThinkPad T14 Gen 5, which was 
> tested by sdk@.
> 
> The behavior for non-mmap consumers remains unchanged, and error frames 
> are still skipped by the driver.
> 
> I had tested this diff with the following webcams and no regressions
> were noticed:
>  - Azurewave, USB camera
>  - LG UltraFine Display Camera
>  - Jabra PanaCast 20
> 
> Feedback? Tests? Ok?

Thank you for fixing the webcam in my Thinkpad T15g5!

I tested:
- 8SSC21K64624V1SR47D21S9 Integrated Camera: (T15g5 cam)
- Sunplus IT Co Full HD webcam
- Logitech Webcam C270

They all work.

However, ffplay is now showing errors when playing an mjpeg stream on the 
Logitech Webcam C270:
[mjpeg @ 0xb22d21ed800] unable to decode APP fields: Invalid data found when processing input
[mjpeg @ 0xb22d21ed800] unable to decode APP fields: Invalid data found when processing input
[mjpeg @ 0xb22d21ed800] unable to decode APP fields: Invalid data found when processing input
...





