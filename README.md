# My Quick Windows install script

## Requirements

- PowerShell v7.2 or newer

## More Customization

- script by [@christitustech](https://github.com/christitustech)

```ps
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -Command "Start-Process powershell.exe -verb runas -ArgumentList 'irm https://christitus.com/win | iex'
```

- my configs [here](configs\winutil_configs.json)

## Troubleshoot

- fix scripts not allowed

```ps
Set-ExecutionPolicy RemoteSigned
```
