## Boot Container
```
docker build -t signal_cli .
docker run --name signal_cli -dit signal_cli 
```

## To use it as master device

### Standart Register
```
signal-cli -a {phone} register
```

<br>

### Captcha Register
Sometimes the Signal server requires a captcha token for registering a new account. If your IP address is not deemed trustworthy enough.

Get your captcha token from
https://signalcaptchas.org/registration/generate.html

Open the developer tools and check the console. You will see something captcha token there (**Everything after signalcaptcha:// is the captcha token**)

<img width="615" alt="Screen Shot 2022-04-13 at 22 59 10" src="https://user-images.githubusercontent.com/51231605/163271309-01e81980-c01e-49b4-8c10-1bdd98761a5b.png">

Register with your token
```
signal-cli -a {phone} register --captcha {captcha_token}
```

After that you should have an sms that has verify code in it. Than just verify it by typing:
```
signal-cli -a {phone} verify {code}
```

## Link Device via QR Code
```
signal-cli link -n "device-name-test" | tee >(xargs -L 1 qrencode -t utf8)
```

After linking was successful, you need to execute the receive command to get the list of contacts and groups from the main device.
```
signal-cli -u {phone} receive
```

Trust new identity
```
signal-cli trust -a {phone}
```

Try to send a message
```
signal-cli -a {phone} send -m "This is a test Signal message" {recipient_phone}
```
