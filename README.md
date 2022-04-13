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

#### Get your captcha token
https://signalcaptchas.org/registration/generate.html

Open the developer tools and check the console. You will see something like:
[IMAGE HERE]

**Everything after signalcaptcha:// is the captcha token**

#### Register with your token now
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